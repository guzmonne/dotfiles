" Change the map leader.
let mapleader=" "

" Open a new tmux window using tmux-windownizer
nnoremap <silent> <C-n> :silent !tmux new-window tmux-sessionizer.sh<CR>
nnoremap <silent> <C-p> :silent !tmux new-window tmux-sessions.sh<CR>
nnoremap <silent> ∑ :silent !tmux new-window tmux-notion.sh<CR>

" Git commands
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gf :diffget //3<CR>
nnoremap <silent> <leader>gj :diffget //2<CR>

" Switch to normal mode inside terminal mode
tnoremap <silent> jk <C-\><C-n>

" Shortcut to edit mappings.
nnoremap <silent> <leader>ei :e ~/.config/nvim/init.vim<CR>
nnoremap <silent> <leader>ec :e ~/.config/nvim/main.vim<CR>
nnoremap <silent> <leader>ep :e ~/.config/nvim/plugins.vim<CR>
nnoremap <silent> <leader>ef :e ~/.config/nvim/functions.vim<CR>
nnoremap <silent> <leader>em :e ~/.config/nvim/mappings.vim<CR>

" Shortcut to save the current buffer
nnoremap <silent> <leader>s :w<CR>
inoremap <silent> <C-s> <Esc>:w<CR>
vnoremap <silent> <C-s> <Esc>:w<CR>
nnoremap <silent> <C-s> :w<CR>

" Shortcut to save and quit the curren buffer.
nnoremap <silent> <leader>wq :wq<CR>

" Shortcut to give execute permissions to a file
nnoremap <silent> <leader>cx :!chmod +x %<CR>

" Shortcut to source NVIM configuration
nnoremap <leader>sc :source ~/.config/nvim/init.vim<CR>

" Use ;; for escape
inoremap jk <Esc>
inoremap kj <Esc>

" Go to the next buffer
nnoremap <silent> <TAB> :bn<CR>
nnoremap <silent> <S-TAB> :bp<CR>

" Replay the last command change
nnoremap <leader>@ @:<CR>

" Close split but keep buffer
nnoremap <silent> <leader>qs <C-w>q<CR>

" Close buffer but keep split
nnoremap <silent> <leader>qq :bd<CR>

" Close vim without saving
nnoremap <silent> <leader>qa :qa!<CR>

" Save the current buffers and close vim
nnoremap <silent> <leader>qw :xa<CR>

" Save everything except the current buffer
command! BufOnly execute '%bdelete|edit #|normal `"'
nnoremap <silent> <leader>q1 :BufOnly<CR>

" Remap Q to quit and q to command
nnoremap Q q

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
" Replace the text object under the current cursor using lsp.
nnoremap <leader>r :lua require('lsp_rename').lsp_rename()<CR>

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
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==

" Simpler splits
nnoremap <silent> <leader>v :vsplit<CR>
nnoremap <slient> <leader>h :hsplit<CR>

" Better block tabbing
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Disable arrow keys
noremap <up> <nop>
noremap <right> <nop>
noremap <down> <nop>
noremap <left> <nop>

" Move C-u to C-j
" nnoremap <C-j> <C-d>zz
nnoremap <C-j> <cmd>lua require'neoscroll'.scroll(12, true, 150)<CR>
nnoremap <C-k> <cmd>lua require'neoscroll'.scroll(-12, true, 150)<CR>
" nnoremap <C-k> <C-u>zz

" Configure Telescope
nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<CR>
nnoremap <leader>fr <cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<CR>
nnoremap <leader>fg <cmd>Telescope git_files<CR>
nnoremap <leader>ex <cmd>Telescope file_browser<CR>
nnoremap <leader>ft <cmd>Telescope tags<CR>
nnoremap <leader>gr <cmd>Telescope grep_string<CR>
nnoremap <leader>rg <cmd>lua require'telescope.builtin'.live_grep()<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
nnoremap <leader>ma <cmd>Telescope man_pages<CR>
nnoremap <leader>ds <cmd>lua require'telescope.builtin'.lsp_document_symbols()<CR>

" Apply quotes under the selected word
nnoremap <leader>;q bi"<ESC>ea"<ESC>

" Configure keybindings for Trouble
nnoremap <leader>xx :TroubleToggle<CR>
nnoremap <leader>xw :TroubleToggle lsp_workspace_diagnostics<CR>
nnoremap <leader>xd :TroubleToggle lsp_document_diagnostics<CR>
nnoremap <leader>xq :TroubleToggle quickfix<CR>
nnoremap <leader>xl :TroubleToggle loclist<CR>
nnoremap gR :TroubleToggle lsp_references<CR>

" Get current path
nnoremap <leader>pwd :let @+ = expand("%:p")<CR>\|:echo expand("%:p")<CR>
nnoremap <leader>zf v%zf

" Capitalize the first letter of the word under the cursor.
nnoremap <leader>cc m`lb~``
