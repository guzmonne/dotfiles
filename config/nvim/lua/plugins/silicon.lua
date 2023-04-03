-- Silicon Configuration
require('silicon').setup({
  output = {
    clipboard = true,
    path = vim.fn.getenv('HOME') .. "/Projects/Silicon",
    format = "silicon_[year][month][day]_[hour][minute][second].png",
  },
  font = 'CartographCF Nerd Font=22',
  themes_path = "/Users/guzmanmonne/.config/bat",
  theme = 'Enki-Tokyo-Night',
  -- theme = vim.fn.getenv('HOME') .. "/Projects/Personal/colors/tokyonight.tmLanguage",
  -- Background and shadow configuration for the screenshot
  background = '#828997',         -- (string) The background color for the screenshot.
  shadow = {
    blur_radius = 0.0,         -- (number) The blur radius for the shadow, set to 0.0 for no shadow.
    offset_x = 2,              -- (number) The horizontal offset for the shadow.
    offset_y = 2,              -- (number) The vertical offset for the shadow.
    color = '#555'             -- (string) The color for the shadow.
  },
  pad_horiz = 100,             -- (number) The horizontal padding.
  pad_vert = 80,               -- (number) The vertical padding.
  line_number = false,         -- (boolean) Whether to show line numbers in the screenshot.
  line_pad = 0,                -- (number) The padding between lines.
  line_offset = 1,             -- (number) The starting line number for the screenshot.
  tab_width = 2,               -- (number) The tab width for the screenshot.
  gobble = false,              -- (boolean) Whether to trim extra indentation.
  highlight_selection = false, -- (boolean) Whether to capture the whole file and highlight selected lines.
  round_corner = true,
  window_controls = true,      -- (boolean) Whether to show window controls (minimize, maximize, close) in the screenshot.
  -- Watermark configuration for the screenshot
  watermark = {
    text = ' @guzmonne',
  },
  window_title = function()
    return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ':~:.')
  end,
})
