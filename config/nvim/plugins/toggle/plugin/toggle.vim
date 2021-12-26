" Prevent loading the file twice
if exists ('g:loaded_gux_toggle') | finish | endif

" Save user options
let s:save_cpo = &cpo
" Reset them to defaults.
set cpo&vim

" Command to run the plugin.
command! GuxToggleWindow lua require'toggle'.toggle_window()

" Common practice to prevent sequence of single character flags
" to interfere with the plugin.
let &cpo = s:save_cpo
unlet s:save_cpo

" Flag so that we don't load the file twice.
let g:loaded_gux_toggle = 1
