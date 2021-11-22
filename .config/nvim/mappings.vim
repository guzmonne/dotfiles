  " Change the map leader.
  let mapleader=" "

  " Open a new tmux window using tmux-windownizer
  nnoremap <silent> <C-n> :silent !tmux new-window tmux-sessionizer.sh<CR>
  nnoremap <silent> <C-p> :silent !tmux new-window tmux-sessions.sh<CR>
  nnoremap <silent> ∑ :silent !tmux new-window tmux-notion.sh<CR>

  " Start a `git add -p` workflow on a new window.
  nnoremap <silent> <leader>ga :tab Git add -p<CR>

  " Start a `git rebase -i main` workflow on a new tab.
  nnoremap <silent> <leader>gr :tab Git rebase -i main<CR>

  " Checkout main and pull last changes.
  nnoremap <silent> <leader>gm :!cd ../main && git pull origin --rebase<CR>

  " Git commands
  nnoremap <silent> <leader>gs :Git status<CR>
  nnoremap <silent> <leader>gc :Git commit<CR>

  " Fold all code except git hunks
  nnoremap <silent> <leader>gf :GitGutterFold<CR>

  " Switch to normal mode inside terminal mode
  tnoremap <silent> jk <C-\><C-n>

  " Shortcut to edit mappings.
  nnoremap <silent> <leader>ei :e ~/.config/nvim/init.vim<CR>
  nnoremap <silent> <leader>ec :e ~/.config/nvim/main.vim<CR>
  nnoremap <silent> <leader>ep :e ~/.config/nvim/plugins.vim<CR>
  nnoremap <silent> <leader>ef :e ~/.config/nvim/functions.vim<CR>
  nnoremap <silent> <leader>em :e ~/.config/nvim/mappings.vim<CR>
  nnoremap <leader>ee :e ~/.config/nvim/
  nnoremap <silent> <leader>cc :CocConfig<CR>
  nnoremap <silent> <leader>cf <Plug>(coc-format-selected)
  vnoremap <silent> <leader>cf <Plug>(coc-format-selected)


  " Shortcut to save the current buffer
  nnoremap <silent> <leader>s :w<CR>
  inoremap <silent> <C-s> <Esc>:w<CR>
  nnoremap <silent> <C-s> :w<CR>

  " Shortcut to save and quit the curren buffer.
  nnoremap <silent> <leader>wq :wq<CR>

  " Shortcut to give execute permissions to a file
  nnoremap <silent> <leader>cx :!chmod +x %<CR>

  " Close current buffer
  nnoremap <silent> <leader>w :w<CR>:q!<CR>

  " Shortcut to source NVIM configuration
  nnoremap <leader>sc :source ~/.config/nvim/init.vim<CR>

  " Use ;; for escape
  inoremap jk <Esc>

  " Go to the next buffer
  nnoremap <silent> <TAB> :bn<CR>
  nnoremap <silent> <S-TAB> :bp<CR>
  nnoremap <silent> <leader>bd :%bd\|bd#<CR>
  nnoremap <slient> <leader>be :%bd\|e#\|bd#<CR>

" List buffers using fzf
nnoremap <silent> <leader>fb :Buffers!<CR>

" List files using fzf
nnoremap <silent> <leader>ff :Files!<CR>

" List git files using fzf
nnoremap <silent> <leader>fg :GFiles!<CR>

" Select colorschem using fzf
nnoremap <silent> <leader>fc :Colors<CR>

" Search in opened buffers
nnoremap <silent> <leader>fl :Lines!<CR>

" Search in opened buffer
nnoremap <silent> <leader>fa :BLines!<CR>

" Search in tags
nnoremap <silent> <leader>ft :BTags!<CR>

" Search in all project tags
nnoremap <silent> <leader>fa :Tags!<CR>

" Search in directory
nnoremap <leader>rg :Rg!<space>

" Search in history
nnoremap <silent> <leader>fh :History:<CR>

" Replay the last command change
nnoremap <leader>r @:<CR>

" Toggle the tagbar
nnoremap <silent> <leader>tt :TagbarToggle<CR>

" Close buffer
nnoremap <silent> <leader>q :bw<CR>

" Close split but keep buffer
nnoremap <silent> <leader>qs <C-w>q<CR>

" Close buffer but keep split
nnoremap <silent> <leader>qb :bd<CR>

" Close vim without saving
nnoremap <silent> <leader>qq :qa!<CR>
nnoremap <silent> qq :qa!<CR>

" Save the current buffers and close vim
nnoremap <silent> <leader>qw :xa<CR>

" Set the cwd to the current directory
nnoremap <silent> <leader>cd :cd%:p:h<CR>

" Remap Q to quit and q to command
nnoremap Q q
nnoremap q <Nop

" Handle diffput - From cursor file to the target
nnoremap <leader>dp :diffput //1<CR>
nnoremap <silent> <leader>] ]c
nnoremap <silent> <leader>[ [c

" Handle navigation
nnoremap <silent> <C-j> <C-d>
nnoremap <silent> <C-k> <C-u>

" Harpoon mappings
nnoremap <silent> <C-h> :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent> <leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent> <leader>2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent> <leader>3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent> <leader>4 :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <silent> <leader>, :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent> t1 :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <silent> t2 :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <silent> t3 :lua require("harpoon.term").gotoTerminal(3)<CR>
nnoremap <silent> t4 :lua require("harpoon.term").gotoTerminal(4)<CR>

" Replace all the occurances of what you have visually selected.
vnoremap <C-r> <Esc>:%s/<c-r>=GetVisual()<cr>//g<left><left>

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
inoremap <C-j> :m .+1<CR>==
inoremap <C-k> :m .-2<CR>==
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

" Configure vim-zenroom2
noremap <silent> <leader>z :Goyo<CR>
