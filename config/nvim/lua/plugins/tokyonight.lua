-- Configure tokyonight --
require("tokyonight").setup({
    style = "night",
    light_style = "day",
    transparent = true,
    terminal_colors = true,
    styles = {
        functions = {italic = false},
        comments = {italic = true},
        keywords = {italic = false},
        sidebars = "none",
        floats = "none"
    },
    hide_inactive_statusline = false,
    dim_inactive = true,
    lualine_bold = true,
    -- Change the "hint" color to Orange.
    on_colors = function(colors)
        colors.hint = colors.orange
    end,
})

vim.cmd [[colorscheme tokyonight-night]]
