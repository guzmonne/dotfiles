-- ╭────────────────╮
-- │ Default config │
-- ╰────────────────╯

---@class LlmStreamConfig

local config = {
	-- Log file location
	log_file = vim.fn.stdpath("log"):gsub("/$", "") .. "/llm-stream.nvim.log",

	-- Styling for popup
	style_popup_border = "single",
	style_popup_margin_bottom = 8,
	style_popup_margin_left = 1,
	style_popup_margin_right = 2,
	style_popup_margin_top = 2,
	style_popup_max_width = 160,
}

return config
