" Specify a directory for plugins call plug#begin('~/.config/nvim/plugged')
" Configure your plugins here.
" Hint: Make sure you use single quotes.
call plug#begin('~/.config/nvim/plugged')

Plug 'jvirtanen/vim-hcl'
Plug 'mfussenegger/nvim-lint'
Plug 'stevearc/dressing.nvim'
Plug 'lepture/vim-jinja'
Plug 'folke/zen-mode.nvim'
Plug 'RRethy/vim-illuminate'
Plug 'stevearc/oil.nvim'
Plug 'brenoprata10/nvim-highlight-colors'
Plug 'github/copilot.vim'
Plug 'godlygeek/tabular'
Plug 'Aasim-A/scrollEOF.nvim'
Plug 'kevinhwang91/promise-async'
Plug 'mbbill/undotree'
Plug 'folke/which-key.nvim'
Plug 'j-hui/fidget.nvim', { 'branch': 'legacy' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'johmsalas/text-case.nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'ThePrimeagen/harpoon'
Plug 'editorconfig/editorconfig-vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'folke/trouble.nvim'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'
Plug 'onsails/lspkind-nvim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'numToStr/Comment.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Don't configure any plugin under this line.
call plug#end()

