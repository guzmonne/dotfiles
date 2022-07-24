filetype plugin indent on       " allow auto-indenting by file-type
filetype plugin on

" Custom plugin manager. Run :help backpack for more information.
packadd! backpack
lua vim.cmd('helptags '..vim.fn.stdpath('data')..'/site/pack/backpack/opt/backpack/doc')

" Use Plug to handle plugins
source ~/.config/nvim/plug.vim

" Load additional configurations
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/functions.vim
source ~/.config/nvim/mappings.vim
source ~/.config/nvim/main.vim
source ~/.config/nvim/setup.lua
