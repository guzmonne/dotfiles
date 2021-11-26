" Prevent loading the file twice
if exists ('g:loaded_gux_backpack') | finish | endif

" Save user options
let s:save_cpo = &cpo
" Reset them to defaults.
set cpo&vim

" NOTE: Here you would expose functions of the plugin.
" command! GuxLspRename lua require'lsp_rename'.lsp_rename()

" Common practice to prevent sequence of single character flags
" to interfere with the plugin.
let &cpo = s:save_cpo
unlet s:save_cpo

" Flag so that we don't load the file twice.
let g:loaded_gux_backpack = 1

