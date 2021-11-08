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
