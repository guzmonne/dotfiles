-- Confiugure Plugins
require('plugins')
require('user')

-- Extend NeoVim configuration

-- LSP Diagnostics Options Setup
local sign = function(opts)
    vim.fn.sign_define(opts.name, {texthl = opts.name, text = opts.text, numhl = ''})
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {source = 'always', header = '', prefix = ''}
})

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match.
-- noinsert: Do no insert text until a selection is made.
-- noselect: Do not select, force to select one from the menu.
-- shortness: avoid showing extra messages when using completion.
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + {c = true}
vim.api.nvim_set_option('updatetime', 300)

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
vim.cmd([[
set signcolumn=yes
]])

-- Treesitter folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- Vimspector Configuration
vim.cmd([[
let g:vimspector_sidebar_width = 85
let g:vimspector_bottombar_height = 15
let g:vimspector_terminal_maxwidth = 70
]])

vim.cmd([[
nnoremap <F9> <CMD>call vimspector#Launch()<CR>
nnoremap <F5> <CMD>call vimspector#StepOver()<CR>
nnoremap <F8> <CMD>call vimspector#Reset()<CR>
nnoremap <F11> <CMD>call vimspector#StepOver()<CR>")
nnoremap <F12> <CMD>call vimspector#StepOut()<CR>")
nnoremap <F10> <CMD>call vimspector#StepInto()<CR>")

nnoremap Db <CMD>call vimspector#ToggleBreakpoint()<CR>
nnoremap Dw <CMD>call vimspector#AddWatch()<CR>
nnoremap De <CMD>call vimspector#Evaluate()<CR>
]])

