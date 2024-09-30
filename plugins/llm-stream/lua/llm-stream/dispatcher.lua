-- ╭────────────────────────────────────────────────────────────────────────╮
-- │ Dispatcher handles the communication between the plugin and llm-stream │
-- ╰────────────────────────────────────────────────────────────────────────╯

local logger = require("llm-stream.logger")
local tasker = require("llm-stream.tasker")
local helpers = require("llm-stream.helpers")

local M = {
	config = {},
	providers = {},
}

---Runs an llm-stream query
---@param buf number | nil Buffer number
---@param args table Llm-Stream arguments
---@param handler function Response handler
---@param on_exit function | nil Optional on_exit handler
---@param callback function | nil Optional callback handler
M.query = function(buf, args, handler, on_exit, callback)
	-- Make sure handler is a function
	if type(handler) ~= "function" then
		logger.error(
			string.format("query() expects a handler function, but got %s:\n%s", type(handler), vim.inspect(handler))
		)
		return
	end

	local qid = helpers.uuid()
	tasker.set_query(qid, {
		timestamp = os.time(),
		buf = buf,
		args = args,
		handler = handler,
		on_exit = on_exit,
		raw_response = "",
		response = "",
		first_line = -1,
		last_line = -1,
		ns_id = nil,
		ex_id = nil,
	})

	local out_reader = function()
		local buffer = ""

		---Processes the lines coming to stdout by calling the handler function with each new
		---chunk, and accumulating the total output inside the `query` table.
		---@param lines_chunk string
		local function process_lines(lines_chunk)
			local qt = tasker.get_query(qid)
			if not qt then
				return
			end

			local lines = vim.split(lines_chunk, "\n")
			for _, content in ipairs(lines) do
				if content ~= "" and content ~= nil then
					qt.raw_response = qt.raw_response .. content .. "\n"
				end

				if content and type(content) == "string" then
					qt.response = qt.response .. content
					handler(qid, content)
				end
			end
		end

		---Closure for uv.read_start(stdout, fn)
		---@param err string | nil Error message
		---@param chunk string | nil Chunk of data
		return function(err, chunk)
			local qt = tasker.get_query(qid)
			if not qt then
				return
			end

			if err then
				logger.error(qt.provider .. " query stdout error: " .. vim.inspect(err))
			elseif chunk then
				-- Add the incoming chunk to the buffer
				buffer = buffer .. chunk

				local last_newline_pos = buffer:find("\n[^\n]*$")

				if last_newline_pos then
					local complete_lines = buffer:sub(1, last_newline_pos - 1)

					-- Save the rest of the buffer for the next chunk
					buffer = buffer:sub(last_newline_pos + 1)

					process_lines(complete_lines)
				end
			else
				-- If there's remaining data in the buffer, process it
				if #buffer > 0 then
					process_lines(buffer)
				end

				if qt.response == "" then
					logger.error(qt.provider .. " response is empty: \n" .. vim.inspect(qt.raw_response))
				end

				-- Run optional on_exit handler
				if type(on_exit) == "function" then
					on_exit(qid)
					if qt.ns_id and qt.buf then
						vim.schedule(function()
							vim.api.nvim_buf_clear_namespace(qt.buf, qt.ns_id, 0, -1)
						end)
					end
				end

				-- Run optional callback handler
				if type(callback) == "function" then
					vim.schedule(function()
						callback(qt.response)
					end)
				end
			end
		end
	end

	tasker.run(buf, "llm-stream", args, nil, out_reader(), nil)
end

-- Creates the response handler, usually used along the M.query method.
---@param buf number | nil Buffer to insert response into
---@param win number | nil Window to insert response into
---@param line number | nil Line to insert response into
---@param first_undojoin boolean | nil Whether to skip first undojoin
---@param prefix string | nil Prefix to insert before each response line
---@param cursor boolean Whether to move cursor to the end of the response
M.create_handler = function(buf, win, line, first_undojoin, prefix, cursor)
	buf = buf or vim.api.nvim_get_current_buf()
	prefix = prefix or ""

	local first_line = line or vim.api.nvim_win_get_cursor(win or 0)[1] - 1
	local finished_lines = 0
	local skip_first_undojoin = not first_undojoin

	local hl_handler_group = "LlmStreamHandlerStandout"
	vim.cmd("highlight default link " .. hl_handler_group .. " CursorLine")

	local ns_id = vim.api.nvim_create_namespace("LlmStreamHandler_" .. helpers.uuid())

	local ex_id = vim.api.nvim_buf_set_extmark(buf, ns_id, first_line, 0, {
		strict = false,
		right_gravity = false,
	})

	local response = ""

	return vim.schedule_wrap(function(qid, chunk)
		local qt = tasker.get_query(qid)
		if not qt then
			return
		end

		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		-- Undojoin takes previous change into account, so skip it for the first chunk
		if skip_first_undojoin then
			skip_first_undojoin = false
		else
			helpers.undojoin(buf)
		end

		if not qt.ns_id then
			qt.ns_id = ns_id
		end

		if not qt.ex_id then
			qt.ex_id = ex_id
		end

		first_line = vim.api.nvim_buf_get_extmark_by_id(buf, ns_id, ex_id, {})[1]

		-- Clean previous response
		local line_count = #vim.split(response, "\n")
		vim.api.nvim_buf_set_lines(buf, first_line + finished_lines, first_line + line_count, false, {})

		-- Append new response
		response = response .. chunk
		helpers.undojoin(buf)

		-- Prepend prefix to each line
		local lines = vim.split(response, "\n")
		for i, l in ipairs(lines) do
			lines[i] = prefix .. l
		end

		local unfinished_lines = {}
		for i = finished_lines + 1, #lines do
			table.insert(unfinished_lines, lines[i])
		end

		vim.api.nvim_buf_set_lines(
			buf,
			first_line + finished_lines,
			first_line + finished_lines,
			false,
			unfinished_lines
		)

		local new_finished_lines = math.max(0, #lines - 1)
		for i = finished_lines, new_finished_lines do
			vim.api.nvim_buf_add_highlight(buf, qt.ns_id, hl_handler_group, first_line + i, 0, -1)
		end
		finished_lines = new_finished_lines

		local end_line = first_line + #vim.split(response, "\n")
		qt.first_line = first_line
		qt.last_line = end_line - 1

		-- Move cursor to the end of the response
		if cursor then
			helpers.cursor_to_line(end_line, buf, win)
		end
	end)
end

return M
