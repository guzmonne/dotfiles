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
" Codepilot mappings
imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")

" Only run the `Copilot enable` command if the `Copilot` command is defined.
if exists(':Copilot')
  " Enable Copilot on every file on enter
  Copilot enable
endif

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
