-- Lualine --
local tokyonight = require 'lualine.themes.tokyonight'

tokyonight.normal.a.bg = '#9ece6a'
tokyonight.normal.b.fg = '#9ece6a'

tokyonight.insert.a.bg = '#7aa2f7'
tokyonight.insert.b.fg = '#7dcfff'

function Codeium() return vim.fn['codeium#GetStatusString']() end

function Codeium_lualine()
    return "codeium " .. Codeium()
end

require 'lualine'.setup({
    options = { theme = tokyonight, component_separators = '|', section_separators = '' },
    sections = { lualine_c = { 'filename', Codeium_lualine }, lualine_x = { 'filetype' }, lualine_y = { 'progress' } }
})

