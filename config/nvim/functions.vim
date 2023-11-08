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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Zoom / Restore window.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Find Nearest
" Source: http://vim.1045645.n5.nabble.com/find-closest-occurrence-in-both-directions-td1183340.html
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! FindNearest(pattern)
  let @/=a:pattern
  let b:prev = search(a:pattern, 'bncW')
  if b:prev
    let b:next = search(a:pattern, 'ncW')
    if b:next
      let b:cur = line('.')
      if b:cur - b:prev == b:next - b:cur
        " on a match
      elseif b:cur - b:prev < b:next - b:cur
        ?
      else
        /
      endif
    else
      ?
    endif
  else
    /
  endif
endfunction

function! s:Camelize(range) abort
  if a:range == 0
    s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g
  else
    s#\%V\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)\%V#\u\1\2#g
  endif
endfunction

function! s:Snakeize(range) abort
  if a:range == 0
    s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
  else
    s#\%V\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)\%V#\l\1_\l\2#g
  endif
endfunction

function! ToggleComplete()
  " Get the current line
  let l:line = getline('.')

  " Get the char to test with the help of a pattern: ' '  or 'x'.
  " \zs and \ze lets you retrieve only the parte between themselves:
  let l:char = matchstr(l:line, '\[\zs.\ze]')

  " Invert the value
  if l:char == 'x'
    let l:char = ' '
  else
    let l:char = 'x'
  endif

  " Replace the current line with a new one, with the right size.
  " char substituted
  call setline(line('.'), substitute(l:line, '\[\zs.\ze]', l:char, ''))
endfunction

" Toggle the statusline
let s:hidden_all = 0
function! ToggleHiddenAll()
  if s:hidden_all  == 0
    let s:hidden_all = 1
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
    set nocursorline
    set nonumber
    set norelativenumber
  else
    let s:hidden_all = 0
    set showmode
    set ruler
    set laststatus=2
    set showcmd
    set cursorline
    set number
    set relativenumber
  endif
  Gitsigns toggle_signs

endfunction

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

" Trim extra lines at the end of a file
function TrimEndLines()
  let l:save = winsaveview()
  keeppatterns %s/\($\n\s*\)\+\%$//e
  call winrestview(l:save)
endfunction

" Add a new line at the end of a file
function! AddLastLine()
  if getline('$') !~ "^$"
    call append(line('$'), '')
  endif
endfunction

" Remove all traling whitespaces
function! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

" Set a light theme
function! Light()
  echom "set bg=light"
  set bg=light
  set list
endfunction

" Set a dark theme
function! Dark()
  echom "set bg=dark"
  set bg=dark
  set nolist
endfunction

" Toggle themes
function! ToggleLightDark()
  if &bg ==# "light"
    call Dark()
  else
    call Light()
  endif
endfunction

command! -nargs=1 FN call FindNearest(<q-args>)
command! -range CamelCase silent! call <SID>Camelize(<range>)
command! -range SnakeCase silent! call <SID>Snakeize(<range>)
command! -nargs=1 Silent
\   execute 'silent !' . <q-args>
\ | execute 'redraw!'
