" Filetype
filetype on
filetype plugin on
filetype indent on

set completeopt=menuone,noselect
set fileencoding=utf-8          " Use utf-8 as encoding type for files.
set noignorecase                " case sensitive searches
set showmatch                   " show matching
set nocompatible                " disable compatibility to old-time vi
set hlsearch                    " highlight search
set incsearch                   " incremental search
set autoindent
set smartindent
set cindent
set tabstop=2 shiftwidth=2 expandtab
set nofoldenable                " Deactivate fold use command.
set number                      " add line numbers
set wildmode=longest,list       " get bash-like tab completions
set cc=100,120                  " set a 100 and 120 column border
set mouse=a                     " enable mouse click
set clipboard=unnamedplus       " using system clipboard
set ttyfast                     " Speed up scrolling on vim
set vb t_vb=                    " Disable Beep/Flash
set nowrap                      " Disable line wraping
set ruler                       " Enable line and column display
set hidden                      " Keeps any buffer available
set confirm                     " makes it easier to
set autowriteall                " work with buffers
set wildmenu wildmode=full      "
set splitright                  " Split panes to the right
set splitbelow                  " Split panes to the bottom
set nowritebackup               " Don't write backups.
set cmdheight=1                 " Give more space for displaying messages
set updatetime=300              " Increade the update time
set shortmess+=c                " Don't pass messages to |ins-completion-menu|
set timeoutlen=1000             " Update the time between multiple key presses
"set signcolumn="yes:[1-3]"     " Always show the sign column
set termguicolors               " Use terminal GUI colors.
set signcolumn=yes
" Syntax
syntax on                       " Enable syntax highlighting
" This configuration makes the all the backgrounds transparent
" highlight clear CursorLineNR
" highlight Normal            ctermbg=NONE
" highlight LineNr            ctermbg=NONE
" highlight SignColumn        ctermbg=NONE
" highlight CursorLine        ctermbg=NONE
" highlight CursorLineNR      ctermbg=NONE
" highlight Folded            ctermbg=NONE cterm=bold
" highlight FoldColumn        ctermbg=NONE cterm=bold
" highlight NonText           ctermbg=NONE
" highlight clear LineNr

" Python provider configuration
let g:python3_host_prog = '/usr/local/bin/python3'
" Remove Python2 support
let g:loaded_python_provider = 0

" Allow syntax highlighting in markdown
let g:vim_markdown_fenced_languages = ['html', 'python', 'console=sh', 'bash=sh', 'javascript', 'typescript']

set exrc                            " Source coniguration every time I enter a new project
set guicursor=                      " Set the guicursor to always be a block
set relativenumber                  " Set relative numbers
set nu                              " Set the line number instead of the 0 number at the current line
set nohlsearch                      " Hide the search highlight after present enter
set noerrorbells                    " Disable error bells sounds
set nobackup                        " Don't backup files
set noswapfile                      " Disable the use of swapfiles
set undodir=~/.vim/undodir          " Sets the location of the undo dir.
set undofile                        " Used with plugins. Need for research.
set scrolloff=12                    " Make vim start scrolling 8 lines from the end

" Enable syntax highlighting on markdown fenced codes.

augroup GUX
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
  autocmd BufWritePre *.ts,*.js,*.jsx,*.tsx EslintFixAll
  autocmd BufWritePre *.ts,*.js,*.jsx,*.tsx Prettier
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd BufLeave term://* stopinsert
  autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
  autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END

augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END
