" Mods commands
command! -range -nargs=0 ModsEditor :'<,'>!mods --api ollama --model hermes2 --role editor --no-cache
command! -range -nargs=0 ModsExplain :'<,'>w !mods --api ollama --model hermes2 "explain this, be very succint" --no-cache
command! -range -nargs=* ModsRefactor :'<,'>!mods --api ollama --model hermes2 --role writer --no-cache
command! -range -nargs=* ModsGPTWriter :'<,'>!mods --role writer --no-cache
command! -range -nargs=+ Mods :'<,'>w !mods <q-args>

" Set the python executable to use.
let g:python3_host_prog = '/opt/homebrew/opt/python@3.11/libexec/bin/python'

" Set smooth scrolling?
set t_TI=^[[4?h
set t_TE=^[[4?l

" You might have to force true color when using regular vim inside tmux as the
" colorscheme can appear to be grayscale with "termguicolors" option enabled.
if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

syntax on
set termguicolors

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable ZenMode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! GoFullZen() abort
  ZenMode
  set wrap
  set nolinebreak
  set lbr
  set textwidth=0 wrapmargin=0
  set conceallevel=1
endfunction
command! GoFullZen call GoFullZen()
function! GoZen() abort
  vertical resize 81
  " setlocal spell spelllang=en_us
  set wrap
  set nolinebreak
  set lbr
  set textwidth=0 wrapmargin=0
  set conceallevel=1
endfunction
command! GoZen call GoZen()

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

" Updated Strip trailing empty newlines
function! TrimTrailingLines()
  " Save the current cursor position
  let currentPos = getpos(".")

  let lastLine = line('$')
  let lastNonBlankLine = prevnonblank(lastLine)
  if lastLine > lastNonBlankLine + 1 " Check if there's more than one empty line
    " We want to delete from the line right after the last non-blank line
    " to the second-to-last line of the file. If there's only one new line,
    " this will do nothing.
    silent! execute lastNonBlankLine + 2 . ",$delete _"
  endif

  " Restore the saved cursor position
  call setpos('.', currentPos)
endfunction

" Remove all traling whitespaces
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

" Replace all the occurances of what you have visually selected.
vnoremap <C-r> <Esc>:%s/<c-r>=GetVisual()<cr>//g<left><left><c-r>=GetVisual()<cr>
" Use F6 to copy the current buffer path into the clipboard
nnoremap <F6> :let @+=expand('%:p')<CR>

augroup GUX
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
  autocmd BufWritePre * :call TrimTrailingLines()

  " Remove line numbers in terminal mode.
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd BufLeave term://* stopinsert

  " Support comments on JSON files.
  autocmd FileType json syntax match Comment +\/\/.\+$+

  " Terraform format
  autocmd BufWritePre *.tfvars lua vim.lsp.buf.format({ async = true })
  autocmd BufWritePre *.tf lua vim.lsp.buf.format({ async = true })

  " Flash the selection when highlighting.
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()

  " Disable diagnostics in node modules (0 is current buffer only)
  autocmd BufRead */node_modules/* :lua vim.lsp.diagnostic.disable(0)
  autocmd BufNewFile */node_modules/* :lua vim.lsp.diagnostic.disable(0)

  " Cursorline transparency
  autocmd ColorScheme * highlight CursorLine guibg=#0f0f0f ctermbg=none

  " Jinja Highlight
  au BufNewFile,BufRead *.tera set ft=jinja

  " Open all folds
  autocmd BufReadPost,FileReadPost * normal zR
augroup END
