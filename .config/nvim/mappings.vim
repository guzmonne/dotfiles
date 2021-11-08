" Change the map leader.
let mapleader=";"

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

" Shortcut to source NVIM configuration
nnoremap <leader>sc :source ~/.config/nvim/init.vim<CR>

" Use ;; for escape
vnoremap ;; <Esc> 
inoremap ;; <Esc>

" Use ;; to remove highlights
nnoremap <silent> <leader><leader> :nohlsearch<CR><C-L>

" Go to the next buffer
nnoremap <silent> <leader>bn :bn<CR>
nnoremap <silent> <leader>bp :bp<CR>

" Close buffer
nnoremap <silent> <leader>ww :w<CR>:bd<CR>

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
nnoremap <silent> <leader>ft :Tags!<CR>

" Search in directory
nnoremap <silent> <leader>rg :Rg!<space>

" toggle colors to optimize based on light or dark background
nnoremap <silent> <leader>c :call ToggleLightDark()<CR>

" Replay the last command change
nnoremap <leader>r @:<CR>

" Toggle the tagbar
nnoremap <silent> <leader>tt :TagbarToggle<CR>

" Close vim without saving
nnoremap <silent> <leader>qq :qa!<CR>

" Save the current buffers and close vim    
nnoremap <silent> <leader>qw :xa<CR>

" Set the cwd to the current directory
nnoremap <silent> <leader>cd :cd%:p:h<CR>
