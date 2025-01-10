vim.api.nvim_create_user_command("TwoHTML", function()
	require("plugins.twohtml.lua.twohtml").twohtml(vim.api.nvim_get_current_win(), {})
end, {})

vim.api.nvim_create_user_command("TwoHTML", function(opts)
	local start_line = opts.line1
	local end_line = opts.line2
	require("cloudbridgeuy/twohtml").twohtml(vim.api.nvim_get_current_win(), {
		range = { start_line, end_line },
	})
end, { range = true })
