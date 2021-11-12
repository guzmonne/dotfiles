" Change the map leader.
let mapleader=";"

" Setup Prettier command.
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

" Open a new tmux window using tmux-windownizer
nnoremap <silent> <C-t> :silent !tmux new-window tmux-sessionizer.sh<CR>
nnoremap <silent> <C-n> :silent !tmux new-window tmux-windownizer.sh<CR>

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
tnoremap <silent> <leader><leader> <C-\><C-n>

" Shortcut to edit mappings.
nnoremap <silent> <leader>ei :e ~/.config/nvim/init.vim<CR>
nnoremap <silent> <leader>ec :e ~/.config/nvim/main.vim<CR>
nnoremap <silent> <leader>ep :e ~/.config/nvim/plugins.vim<CR>
nnoremap <silent> <leader>ef :e ~/.config/nvim/functions.vim<CR>
nnoremap <silent> <leader>em :e ~/.config/nvim/mappings.vim<CR>
nnoremap <leader>ee :e ~/.config/nvim/
nnoremap <silent> <leader>coc :CocConfig<CR>

" Shortcut to save the current buffer
nnoremap <silent> <leader>s :w<CR>
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
vnoremap ;; <Esc> 
inoremap ;; <Esc>

" Use ;; to remove highlights
nnoremap <silent> <leader><leader> :nohlsearch<CR><C-L>

" Go to the next buffer
nnoremap <silent> <TAB> :bn<CR>
nnoremap <silent> <S-TAB> :bp<CR>
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bp :bp<CR>
nnoremap <silent> <leader>w :bd<CR>

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
nnoremap <silent> <leader>rg :Rg!<space>

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
nnoremap <silent> <leader>p :diffput //1<CR>
nnoremap <silent> <leader>] ]c
nnoremap <silent> <leader>[ [c

" Handle navigation
nnoremap <silent> <C-j> <C-d>
nnoremap <silent> <C-k> <C-u>

" Harpoon mappings
nnoremap <silent> <C-h> :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent> 1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent> 2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent> 3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent> 4 :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <silent> <leader>, :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent> h1 :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <silent> h2 :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <silent> h3 :lua require("harpoon.term").gotoTerminal(3)<CR>
nnoremap <silent> h4 :lua require("harpoon.term").gotoTerminal(4)<CR>

