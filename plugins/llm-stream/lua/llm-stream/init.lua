-- LLM-Stream lua plugin for Neovim.
-- https://github.com/cloudbridge/llm-stream.nvim/

-- ╭──────────────────╮
-- │ Module structure │
-- ╰──────────────────╯

local config = require("llm-stream.config")

local M = {
	_Name = "llm-stream",
	config = {},
	logger = require("llm-stream.logger"),
	tasker = require("llm-stream.tasker"),
	dispatcher = require("llm-stream.dispatcher"),
	helpers = require("llm-stream.helpers"),
	render = require("llm-stream.render"),
	spinner = require("llm-stream.spinner"),
}

M.Target = {
	rewrite = 0, -- For replacing the selection, range or the current line
	append = 1, -- For appending after the selection, range or the current line
	prepend = 2, -- For prepending before the selection, range or the current line
	popup = 3, -- For writing into the popup window

	---For writing into a new buffer
	---@param filetype nil | string Filetype (nil = same as the original buffer.)
	---@return table table A table with type=4 and filetype=filetype
	enew = function(filetype)
		return { type = 4, filetype = filetype }
	end,

	---For creating a new horizontal split
	---@param filetype nil | string Filetype (nil = same as the original buffer.)
	---@return table table A table with type=5 and filetype=filetype
	new = function(filetype)
		return { type = 5, filetype = filetype }
	end,

	---For creating a new vertical split
	---@param filetype nil | string Filetype (nil = same as the original buffer.)
	---@return table table A table with type=6 and filetype=filetype
	vnew = function(filetype)
		return { type = 6, filetype = filetype }
	end,

	---For creating a new tab
	---@param filetype nil | string Filetype (nil = same as the original buffer.)
	---@return table table A table with type=7 and filetype=filetype
	tabnew = function(filetype)
		return { type = 7, filetype = filetype }
	end,
}

M._popup = nil

---Closes down a popup
---@return boolean closed Flag set to true if toggle was closed
M._toggle_close = function()
	if
		M._popup
		and M._popup.win
		and M._popup.buf
		and M._popup.close
		and vim.api.nvim_win_is_valid(M._popup.win)
		and vim.api.nvim_buf_is_valid(M._popup.buf)
		and vim.api.nvim_win_get_buf(M._popup.win) == M._popup.buf
	then
		if #vim.api.nvim_list_wins() == 1 then
			M.logger.warning("Can't close the last window.")
		else
			M._popup.close()
			M._popup = nil
		end
		return true
	end

	M._popup = nil
	return false
end

---Calls Llm-Stream
---@param params table Vim command parameters such as range, args, etc.
---@param callback function | nil  # callback after completing the prompt
M.Prompt = function(params, callback)
	local target = 1

	-- Get current buffer
	local buf = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()

	if M.tasker.is_busy(buf) then
		return
	end

	local start_line = params.line1
	local end_line = params.line2

	local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

	local min_indent = nil
	local use_tabs = false

	-- Measure minimal common indentation for lines with content
	for i, line in ipairs(lines) do
		lines[i] = line
		-- Skip whitespace only lines
		if not line:match("^%s*$") then
			local indent = line:match("^%s*")
			-- Contains tabs
			if indent:match("\t") then
				use_tabs = true
			end
			if min_indent == nil or #indent < min_indent then
				min_indent = #indent
			end
		end
	end
	if min_indent == nil then
		min_indent = 0
	end

	local prefix = string.rep(use_tabs and "\t" or " ", min_indent)

	for i, line in ipairs(lines) do
		lines[i] = line:sub(min_indent + 1)
	end

	local selection = table.concat(lines, "\n")

	M._selection_first_line = start_line
	M._selection_last_line = end_line

	local cb = function(args)
		-- Dummy handler
		local handler = function() end
		-- Default on_exit strips trailing backticks if response was markdown snippet
		local on_exit = function(qid)
			local qt = M.tasker.get_query(qid)
			if not qt then
				return
			end

			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end

			local flc, llc
			local fl = qt.first_line
			local ll = qt.last_line

			-- Remove empty lines from the start and end of the response
			while fl < ll do
				-- Get content of first_line and last_line
				flc = vim.api.nvim_buf_get_lines(buf, fl, fl + 1, false)[1]
				llc = vim.api.nvim_buf_get_lines(buf, ll, ll + 1, false)[1]

				if not flc or not llc then
					break
				end

				local flm = flc:match("%S")
				local llm = llc:match("%S")

				-- Break loop if both lines contain non-whitespace characters
				if flm and llm then
					break
				end

				if not flm then
					M.helpers.undojoin(buf)
					vim.api.nvim_buf_set_lines(buf, fl, fl + 1, false, {})
				else
					M.helpers.undojoin(buf)
					vim.api.nvim_buf_set_lines(buf, ll, ll + 1, false, {})
				end
				ll = ll - 1
			end

			-- If fl and ll starts with triple backticks, remove these lines
			if fl < ll and flc and llc and flc:match("^%s*```") and llc:match("^%s*```") then
				-- Remove first line with undojoin
				M.helpers.undojoin(buf)
				vim.api.nvim_buf_set_lines(buf, fl, fl + 1, false, {})
				-- Remove last line
				M.helpers.undojoin(buf)
				vim.api.nvim_buf_set_lines(buf, ll - 1, ll, false, {})
				ll = ll - 2
			end

			qt.first_line = fl
			qt.last_line = ll

			-- Default works for rewrite and enew
			local start = fl
			local finish = ll

			if target == M.Target.append then
				start = M._selection_first_line - 1
			end

			if target == M.Target.prepend then
				finish = M._selection_last_line + ll - fl
			end

			-- Select from first_line to last_line
			vim.api.nvim_win_set_cursor(0, { start + 1, 0 })
			vim.api.nvim_command("normal! V")
			vim.api.nvim_win_set_cursor(0, { finish + 1, 0 })
		end

		-- Cancel possible visual mode before calling the command
		M.helpers.feedkeys("<esc>", "xn")

		local cursor = true
		local filetype = M.helpers.get_filetype(buf)
		local filename = vim.api.nvim_buf_get_name(buf)

		-- Mode specific logic
		if target == M.Target.rewrite then
			-- Delete selection
			vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line - 1, false, {})
			-- Prepare handler
			handler = M.dispatcher.create_handler(buf, win, start_line - 1, true, prefix, cursor)
		elseif target == M.Target.append then
			-- Move cursor to the end of the selection
			vim.api.nvim_win_set_cursor(0, { end_line, 0 })
			-- Put newline after selection
			vim.api.nvim_put({ "" }, "l", true, true)
			-- Prepare handler
			handler = M.dispatcher.create_handler(buf, win, end_line, true, prefix, cursor)
		elseif target == M.Target.prepend then
			-- Move cursor to the start of the selection
			vim.api.nvim_win_set_cursor(0, { start_line, 0 })
			-- Put newline before selection
			vim.api.nvim_put({ "" }, "l", false, true)
			-- Prepare handler
			handler = M.dispatcher.create_handler(buf, win, start_line - 1, true, prefix, cursor)
		elseif target == M.Target.popup then
			M._toggle_close()
			-- Create a new buffer
			local popup_close = nil
			buf, win, popup_close, _ = M.render.popup(
				nil,
				M._Name .. " popup (close with <esc>/<C-c>)",
				function(w, h)
					local top = M.config.style_popup_margin_top or 2
					local bottom = M.config.style_popup_margin_bottom or 8
					local left = M.config.style_popup_margin_left or 1
					local right = M.config.style_popup_margin_right or 1
					local max_width = M.config.style_popup_max_width or 160
					local ww = math.min(w - (left + right), max_width)
					local wh = h - (top + bottom)
					return ww, wh, top, (w - ww) / 2
				end,
				{ persist = false, on_leave = true, escape = true },
				{ border = M.config.style_popup_border or "single", zindex = M.config.zindex }
			)
			-- Set the created buffer as the current buffer
			vim.api.nvim_set_current_buf(buf)
			-- Set the filetype to markdown
			vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
			-- Better text wrapping
			vim.api.nvim_command("setlocal wrap linebreak")
			-- Prepare handler
			handler = M.dispatcher.create_handler(buf, win, 0, false, "", false)

			M._popup = { win = win, buf = buf, close = popup_close }
		elseif type(target) == "table" then
			if target.type == M.Target.new().type then
				vim.cmd("split")
				win = vim.api.nvim_get_current_win()
			elseif target.type == M.Target.vnew().type then
				vim.cmd("vsplit")
				win = vim.api.nvim_get_current_win()
			elseif target.type == M.Target.tabnew().type then
				vim.cmd("tabnew")
				win = vim.api.nvim_get_current_win()
			end

			buf = vim.api.nvim_create_buf(true, true)
			vim.api.nvim_set_current_buf(buf)

			local group = M.helpers.create_augroup("LlmStreamScratchSave" .. M.helpers.uuid(), { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				buffer = buf,
				group = group,
				callback = function(ctx)
					vim.api.nvim_set_option_value("buftype", "", { buf = ctx.buf })
					vim.api.nvim_buf_set_name(ctx.buf, ctx.file)
					vim.api.nvim_command("w!")
					vim.api.nvim_del_augroup_by_id(ctx.group)
				end,
			})

			local ft = target.filetype or filetype
			vim.api.nvim_set_option_value("filetype", ft, { buf = buf })

			handler = M.dispatcher.create_handler(buf, win, 0, false, "", cursor)
		end

		-- Call the command and write the response
		M.dispatcher.query(
			buf,
			vim.tbl_deep_extend("force", { "--preset", "gpt", "--template", "lit", selection }, args or {}),
			handler,
			vim.schedule_wrap(function(qid)
				on_exit(qid)
				vim.cmd("doautocmd User GpDone")
			end),
			callback
		)
	end

	vim.schedule(function()
		cb({})
	end)
end

M.__setup_called = false

---Configures the plugin.
---@param opts llm_stream.Opts LLM-Stream plugin configuration option.
function M.setup(opts)
	if M.__setup_called then
		return
	end

	M.__setup_called = true

	math.randomseed(os.time())

	opts = opts or {}
	if type(opts) ~= "table" then
		M.logger.error(string.format("setup() expects table, but got %s:\n%s", type(opts), vim.inspect(opts)))
		opts = {}
	end

	M.config = vim.deepcopy(config)

	M.logger.setup(opts.log_file or M.config.log_file)
end

return M
