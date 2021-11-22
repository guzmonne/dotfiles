" Specify a directory for plugins call plug#begin('~/.config/nvim/plugged')
" Configure your plugins here.
" Hint: Make sure you use single quotes.
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tribela/vim-transparent'
Plug 'editorconfig/editorconfig-vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'ludovicchabant/vim-gutentags'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'junegunn/goyo.vim'
Plug 'amix/vim-zenroom2'

" Don't configure any plugin under this line.
call plug#end()

" Setup `Prettier` command
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Automatically populate airline fonts
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'deus'

" Disable automatic folding on vim-markdown
let g:vim_markdown_folding_disabled = 1

" Disable default GitGutter mappings
let g:gitgutter_map_keys = 0

" Configure editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Configure tokyonight
let g:tokyonight_style = "night"
let g:tokyonight_italic_keywords = 0
let g:tokyonight_italic_functions = 0
let g:tokyonight_transparent = 1

" Configure Gutentags
let g:gutentags_cache_dir = "~/.ctags_cache"
let g:gutentags_trace = 0 " Change this to 1 if you want to debug gutentags.

" Configure Markdown Preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
