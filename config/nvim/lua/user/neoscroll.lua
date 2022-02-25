-- NeoScroll --
require('neoscroll').setup({
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,
    stop_eof = false,
    -- Can be one of: quadratic, cubic, quartic, quintic, circular, sine
    easing_function = 'sine'
})

