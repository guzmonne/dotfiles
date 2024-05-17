return {
  "folke/tokyonight.nvim",
  opts = {
    style = "night",
    light_style = "day",
    transparent = true,
    terminal_colors = true,
    styles = {
      functions = { italic = false },
      comments = { italic = true },
      keywords = { italic = false },
      sidebars = "transparent",
      floats = "transparent",
    },
    hide_inactive_statusline = true,
    dim_inactive = false,
    lualine_bold = false,
  },
}
