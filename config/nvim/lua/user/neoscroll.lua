-- NeoScroll --
require('neoscroll').setup({
    hide_cursor = true,
    stop_eof = false,
    -- Can be one of: quadratic, cubic, quartic, quintic, circular, sine
    easing_function = 'quadratic'
})

local t = {}
-- Syntax: t[keys] = { function, { function, arguments }}
-- Use the "cubic" easing function
t["<C-u>"] = { "scroll", {"-vim.wo.scroll", "true", "20", [['cubic']]}}
t["<C-d>"] = { "scroll", {"vim.wo.scroll", "true", "20", [['cubic']]}}

t["<C-b>"] = { "scroll", {"-vim.api.nvim_win_get_height(0)", "true", "50", [['cubic']]}}
t["<C-f>"] = { "scroll", {"vim.api.nvim_win_get_height(0)", "true", "50", [['cubic']]}}

-- Pass "nil" to disable the easing animation (constant scrolling speed)
t["<C-y>"] = { "scroll", {"-0.10", "true", "100", nil}}
t["<C-e>"] = { "scroll", {"0.10", "true", "100", nil}}

-- If no easing function is provided, then the default is used
t["zt"] = { "zt", {"10"}}
t["zz"] = { "zz", {"10"}}
t["zb"] = { "zb", {"10"}}

require("neoscroll.config").set_mappings(t)

