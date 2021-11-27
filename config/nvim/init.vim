filetype plugin indent on       " allow auto-indenting by file-type
filetype plugin on

source ~/.config/nvim/main.vim
source ~/.config/nvim/plug.vim
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/functions.vim
source ~/.config/nvim/mappings.vim
source ~/.config/nvim/lsp.lua
source ~/.config/nvim/setup.lua

packadd! backpack

lua require'backpack'.setup()