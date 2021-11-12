" Trim extra lines at the end of a file
function TrimEndLines()
  let l:save = winsaveview()
  keeppatterns %s#\($\n\s*\)\+\%$##
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

