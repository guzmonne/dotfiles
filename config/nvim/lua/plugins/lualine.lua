-- Lualine --
local tokyonight = require("lualine.themes.tokyonight")
local icons = require("lazyvim.config").icons

tokyonight.normal.a.bg = "#9ece6a"
tokyonight.normal.b.fg = "#9ece6a"

tokyonight.insert.a.bg = "#7aa2f7"
tokyonight.insert.b.fg = "#7dcfff"

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts.options = vim.tbl_extend("force", opts.options, {
      theme = tokyonight,
      component_separators = "|",
      section_separators = "",
    })

    opts.sections = vim.tbl_extend("force", opts.sections, {
      lualine_a = { "mode" },
      lualine_c = { "branch" },
      lualine_b = {
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path() },
      },
    })
  end,
}
