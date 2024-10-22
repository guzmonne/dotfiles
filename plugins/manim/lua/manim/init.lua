local loop = vim.loop

local M = {}

local stdio = { stdout = "", stderr = "" }

--- The main function used for passing the main config to lua
---
--- Runs the selected checkpoint.
--- @param start_line number the starting line of the selected text
--- @param end_line number the ending line of the selected text
function M.freeze(start_line, end_line)
	local stdout = loop.new_pipe(false)
	local stderr = loop.new_pipe(false)

	-- Get the text between the start and end line on the current buffer.
	local text = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	vim.print(text)

	if #text == 0 then
		vim.notify("No text selected", vim.log.levels.INFO, { title = "Manim" })
		return
	end

	local start_line_text = text[1]
	local starts_with_comment = false

	if string.find(start_line_text, "^#") then
		starts_with_comment = true
	end

	-- Check if the first character of `start_line_text` begins with `#`.
	if #text == 1 and not starts_with_comment then
		vim.notify("No code after comment", vim.log.levels.INFO, { title = "Manim" })
		return
	end
end

function M.setup()
	vim.api.nvim_create_user_command("ManimCheckpointPaste", function(opts)
		if opts.count > 0 then
			M.checkpoint_paste(opts.line1, opts.line2)
		else
			M.checkpoint_paste(1, vim.nvim_buf_line_count(0))
		end
	end, {})
end

return M
