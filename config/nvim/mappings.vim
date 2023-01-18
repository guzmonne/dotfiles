" Change the map leader.
let mapleader=" "

" Open a new tmux window using tmux-windownizer
nnoremap <silent> <C-n> :silent !tmux new-window tmux-sessionizer.sh<CR>
nnoremap <silent> <C-p> :silent !tmux new-window tmux-sessions.sh<CR>
nnoremap <silent> <C-t> :silent !tmux new-window tmux-toggle.sh<CR>

" Switch to normal mode inside terminal mode
tnoremap <silent> jk <C-\><C-n>

" Shortcut to save the current buffer
inoremap <silent> <C-s> <Esc>:w<CR>
vnoremap <silent> <C-s> <Esc>:w<CR>
nnoremap <silent> <C-s> :w<CR>

" Remap Q to quit and q to command
nnoremap Q q

" Replace all the occurances of what you have visually selected.
vnoremap <C-r> <Esc>:%s/<c-r>=GetVisual()<cr>//g<left><left><c-r>=GetVisual()<cr>

" Select and copy the current line.
nnoremap y y$

" Keep search centered
nnoremap <silent>n nzzzv
nnoremap <silent>N Nzzzv

" Undo break points
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ( (<C-g>u
inoremap ) )<C-g>u
inoremap [ [<C-g>u
inoremap ] ]<C-g>u
inoremap { {<C-g>u
inoremap } }<C-g>u

" Moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Better block tabbing
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Disable arrow keys
noremap <up> <nop>
noremap <right> <nop>
noremap <down> <nop>
noremap <left> <nop>

" Center C-u and C-d
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

" Replace u in visual mode to be the same as y
vnoremap u y

" Remap go to end of the line
nnoremap $ g_
vnoremap $ g_

" g; but with zt
nnoremap g; g;zt

" Undotree keymap
nnoremap <F5> :UndotreeToggle<CR>

" Remap J to maintain the cursor
nnoremap J mzJ`z"

" Remap paste
xnoremap p "_dP
nnoremap y "+y
vnoremap y "+y
nnoremap Y "+Y
nnoremap d "+d
vnoremap d "+d

" Remap Ctrl-C to Esc
inoremap <C-c> <Esc>

" Disable Q
nnoremap Q <nop>

" Move through loclist or quicklist
nnoremap <C-k> <cmd>cnext<CR>zz
nnoremap <C-j> <cmd>cprev<CR>zz
