---@class mods
local M = {}
local Job = require("plenary.job")

-- Table that will hold the functions for the users to consume.
M.fn = {}

-- Gets all the buffer line until the current cursor position.
function M.get_lines_until_cursor()
	local current_buffer = vim.api.nvim_get_current_buf()
	local current_window = vim.api.nvim_get_current_win()
	local cursor_position = vim.api.nvim_win_get_cursor(current_window)

	local row = cursor_position[1]

	local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, row, true)

	return table.concat(lines, "\n")
end

-- Gets the current visual selection.
function M.get_visual_selection()
	local _, srow, scol = unpack(vim.fn.getpos("v"))
	local _, erow, ecol = unpack(vim.fn.getpos("."))

	if vim.fn.mode() == "V" then
		if srow > erow then
			return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
		else
			return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
		end
	end

	if vim.fn.mode() == "v" then
		if srow < erow or (srow == erow and scol <= ecol) then
			return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
		else
			return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
		end
	end

	if vim.fn.mode() == "\22" then
		local lines = {}
		if srow > erow then
			srow, erow = erow, srow
		end
		if scol > ecol then
			scol, ecol = ecol, scol
		end
		for i = srow, erow do
			table.insert(
				lines,
				vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
			)
		end
		return lines
	end
end

-- Makes the `mods` arguments tablr
---@param opts mods.Options `mods` options configuration.
---@param prompt string The prompt to use.
function M.make_mods_spec_args(opts, prompt)
	assert(opts.preset, "llm-stream preset option can't be undefined")
	assert(opts.template, "llm-template option can't be undefined")

	local args = { "--preset", opts.preset, "--template", opts.template, "--vars", opts.vars }

	if opts.suffix ~= nil then
		table.insert(args, "--suffix")
		table.insert(args, opts.suffix)
	end

	table.insert(args, prompt)

	return args
end

-- Writes a string where the current cursor lies.
---@param str string The string to write.
function M.write_string_at_cursor(str)
	if str == nil then
		vim.print("str is nil")
		return
	end

	vim.schedule(function()
		local current_window = vim.api.nvim_get_current_win()
		if current_window == nil then
			vim.print("Current window is nil")
			return
		end

		vim.cmd("undojoin")
		vim.api.nvim_put({ str }, "l", true, true)
	end)
end

-- Gets the prompt.
---@param opts mods.Options `mods` options configuration.
local function get_prompt(opts)
	local replace = opts.replace
	local visual_lines = M.get_visual_selection()
	local prompt = ""

	if visual_lines then
		prompt = table.concat(visual_lines, "\n")
		if replace then
			vim.api.nvim_command("normal! d")
			vim.api.nvim_command("normal! k")
		else
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", false, true, true), "nx", false)
		end
	else
		prompt = M.get_lines_until_cursor()
		-- Only keep up to 16384 characters of the prompt starting from the end.
		prompt = prompt:sub(-16384)
	end

	return prompt
end

local group = vim.api.nvim_create_augroup("ModsLLMAutoGroup", { clear = true })
local active_job = nil

-- Invokes `mods` and streams its output to the editor.
function M.invoke_mods_and_stream_into_editor(key, opts)
	vim.api.nvim_clear_autocmds({ group = group })

	local prompt = get_prompt(opts)
	local args = M.make_mods_spec_args(opts, prompt)

	if active_job then
		active_job:shutdown()
		active_job = nil
	end

	local function parse_and_call(chunk)
		M.write_string_at_cursor(chunk)
	end

	active_job = Job:new({
		command = "e",
		args = args,
		on_stdout = function(_, chunk)
			parse_and_call(chunk)
		end,
		on_exit = function()
			active_job = nil
		end,
	})

	active_job:start()

	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "ModsLLMEscape",
		callback = function()
			if active_job then
				require("fidget.notification").clear("mods:" .. key)
				active_job:shutdown()
				print("Mods streaming cancelled")
				active_job = nil
			end
		end,
	})

	vim.api.nvim_set_keymap("n", "<Esc>", ":doautocmd User ModsLLMEscape<CR>", { noremap = true, silent = true })

	return active_job
end

M.version = "0.1.0" -- x-release-please-version

---@class mods.Opts
local defaults = {}

---@type mods.Opts
M.options = nil

M.loaded = false

---@param opts? mods.Opts
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})

	local function load()
		if M.loaded then
			return
		end

		for key, nestedTable in pairs(M.options) do
			M.fn[key] = function()
				require("fidget").notify(
					"mods:" .. key,
					2,
					{ group = "mods:" .. key, annote = "Running LLM in the background...", ttl = "5" }
				)
				M.invoke_mods_and_stream_into_editor(key, nestedTable)
			end
		end

		M.loaded = true
	end

	load = vim.schedule_wrap(load)

	if vim.v.vim_did_enter == 1 then
		load()
	else
		vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = load })
	end

	vim.api.nvim_create_user_command("Mods", function(cmd)
		M.fn[cmd.args]()
	end, { nargs = "*" })
end

return M
