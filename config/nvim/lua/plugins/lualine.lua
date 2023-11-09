-- Lualine --
local tokyonight = require("lualine.themes.tokyonight")

tokyonight.normal.a.bg = "#9ece6a"
tokyonight.normal.b.fg = "#9ece6a"

tokyonight.insert.a.bg = "#7aa2f7"
tokyonight.insert.b.fg = "#7dcfff"

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options =
      vim.tbl_extend("force", opts.options, { theme = tokyonight, component_separators = "|", section_separators = "" })
  end,
}
