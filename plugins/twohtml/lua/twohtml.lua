local M = {}

---@class twohtml.FloatingWindow
---@field buf number: Buffer number
---@field win number: Window number

---@class twohtml.Options
---@field winid number: Window number
---@field title string?: Title tag to set in the generated HTML code
---@field number_lines boolean?: Show line numbers
---@field width integer?: Width used for items which are either right aligned or repeat a character infinitely
---@field height integer?: Height used for items which are either right aligned or repeat a character infinitely
---@field range integer[]?: Range of rows to use

---@type vim.tohtml.opt
local options = {
	number_lines = false,
	font = "guifont",
	width = 120,
}

--- Create a floating window
---@param config vim.api.keyset.win_config: Floating window configuration
---@param enter boolean: Enter the window
---@return twohtml.FloatingWindow
local function create_floating_window(config, enter)
	if enter == nil then
		enter = false
	end
	local buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	local win = vim.api.nvim_open_win(buf, enter, config)

	return { buf = buf, win = win }
end

M.setup = function(opts)
	opts = opts or {}

	options = vim.tbl_deep_extend("force", options, opts)

	vim.api.nvim_create_user_command("TwoHTML", function(command_opts)
		local start_line = 1
		local end_line = 1

		if opts.count ~= nil then
			start_line = command_opts.line1
			end_line = command_opts.line2
		else
			end_line = vim.api.nvim_buf_line_count(0)
		end

		M.twohtml(vim.api.nvim_get_current_win(), {
			range = { start_line, end_line },
		})
	end, { range = true })
end

--- Convert the buffer shown in the window {winid} to HTML and display it in a floating window.
---@param winid number: Window to convert (defaults to current window)
---@param opts vim.tohtml.opt: Optional TOhtml parameters
M.twohtml = function(winid, opts)
	winid = winid or vim.api.nvim_get_current_win()

	opts = vim.tbl_deep_extend("force", opts, options)

	local temp_width = math.floor(vim.o.columns * 0.8)
	local temp_height = math.floor(vim.o.lines * 0.8)

	vim.print(opts)

	local floating_window = create_floating_window({
		relative = "editor",
		width = temp_width,
		height = temp_height,
		border = "rounded",
		style = "minimal",
		row = math.floor((vim.o.lines - temp_height) / 2),
		col = math.floor((vim.o.columns - temp_width) / 2),
		zindex = 2,
	}, true)

	vim.bo[floating_window.buf].filetype = "html"

	local result = require("tohtml").tohtml(winid, opts)

	vim.api.nvim_buf_set_lines(floating_window.buf, 0, -1, false, result)
end

return M
