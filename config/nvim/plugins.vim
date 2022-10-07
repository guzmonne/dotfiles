" Specify a directory for plugins call plug#begin('~/.config/nvim/plugged')
" Configure your plugins here.
" Hint: Make sure you use single quotes.
call plug#begin('~/.config/nvim/plugged')

Plug 'L3MON4D3/LuaSnip'
Plug 'rafi/vim-venom'
Plug 'mickael-menu/zk-nvim'
Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v2.x' }
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'MunifTanjim/nui.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'editorconfig/editorconfig-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'folke/trouble.nvim'
Plug 'hashivim/vim-terraform'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'karb94/neoscroll.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'romgrk/nvim-treesitter-context'
Plug 'onsails/lspkind-nvim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'xiyaowong/nvim-transparent'
Plug 'windwp/nvim-autopairs'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
Plug 'ray-x/lsp_signature.nvim'

" Don't configure any plugin under this line.
call plug#end()

" Disable automatic folding on vim-markdown
let g:vim_markdown_folding_disabled = 1

" Disable default GitGutter mappings
let g:gitgutter_map_keys = 0

" Configure editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Configure Markdown Preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1

" Convert the current colorscheme into an fzf configuration line
let g:fzf_colors =
\ { 'fg':         ['fg', 'Normal'],
  \ 'bg':         ['bg', 'Normal'],
  \ 'preview-bg': ['bg', 'NormalFloat'],
  \ 'hl':         ['fg', 'Comment'],
  \ 'fg+':        ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':        ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':        ['fg', 'Statement'],
  \ 'info':       ['fg', 'PreProc'],
  \ 'border':     ['fg', 'Ignore'],
  \ 'prompt':     ['fg', 'Conditional'],
  \ 'pointer':    ['fg', 'Exception'],
  \ 'marker':     ['fg', 'Keyword'],
  \ 'spinner':    ['fg', 'Label'],
  \ 'header':     ['fg', 'Comment'] }

" Configure vim-hexokinase
let g:Hexokinase_highlighters = ['virtual']

" Configure Neo-Tree
let g:neo_tree_remove_legacy_commands = 1
