" Specify a directory for plugins call plug#begin('~/.config/nvim/plugged')
" Configure your plugins here.
" Hint: Make sure you use single quotes.
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'preservim/tagbar'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'https://github.com/leafgarland/typescript-vim.git'
Plug 'vim-airline/vim-airline'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tribela/vim-transparent'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'editorconfig/editorconfig-vim'

" Don't configure any plugin under this line.
call plug#end()

" Custom configuration for each plugin
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }

" Disable custom indenter from typescript-vim
let g:typescript_indent_disable = 1

" Automatically populate airline fonts
let g:airline_powerline_fonts = 1

" Disable automatic folding on vim-markdown
let g:vim_markdown_folding_disabled = 1

" Disable default GitGutter mappings
let g:gitgutter_map_keys = 0

" Set GitSigns status line
set statusline+=%{get(b:,'gitsigns_status','')}

" Configure editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

