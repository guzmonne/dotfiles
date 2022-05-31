" Filetype
filetype on
filetype plugin on
filetype indent on

set autoindent                          " Inherit indentation from previous line.
set autoread                            " Reload the file when external changes are detected
set autowriteall                        " Work with buffers
set backspace=indent,eol,start          " Fixes common backspace problems.
set cc=100,120                          " Set a 100 and 120 column border
set cindent
set clipboard=unnamedplus               " Using system clipboard
set cmdheight=1                         " Give more space for displaying messages
set completeopt=longest,menuone,preview " Make the completion menu behave like an IDE
set conceallevel=0                      " Makes `` visible on markdown files.
set confirm                             " Makes it easier to
set exrc                                " Source coniguration every time I enter a new project
set fileencoding=utf-8                  " Use utf-8 as encoding type for files.
set guicursor=                          " Set the guicursor to always be a block
set hidden                              " Keeps any buffer available
set hlsearch                            " Highlight search
set incsearch                           " Incremental search
set matchpairs+=<:>                     " Highlight matching pairs of branckets.
set mouse=a                             " Enable mouse click
set nobackup                            " Don't backup files
set nocompatible                        " Disable compatibility to old-time vi
set noerrorbells                        " Disable error bells sounds
set nofoldenable                        " Deactivate fold use command.
set belloff=all                         " Disable all system bells
set nohlsearch                          " Hide the search highlight after present enter
set noignorecase                        " Case sensitive searches
set noshowmode                          " Remove --INSERT-- and similar text from the message line.
set noswapfile                          " Disable the use of swapfiles
set nowrap                              " Disable line wraping
set nowritebackup                       " Don't write backups.
set number                              " Add line numbers
set numberwidth=4                       " Set number width to 4 (default: 2)
set pumheight=10                        " Pop up menu height
set re=0                                " Stop old regex engine to avoid performance loss.
set norelativenumber                    " Un-set relative numbers
set ruler                               " Enable line and column display
set scrolloff=8                         " Make vim start scrolling 8 lines from the end
set shortmess=F                         " Don't pass messages to |ins-completion-menu|
set showmatch                           " Show matching
set signcolumn=yes
set smartindent
set splitbelow                          " Split panes to the bottom
set splitright                          " Split panes to the right
set termguicolors                       " Use terminal GUI colors.
set timeoutlen=1000                     " Update the time between multiple key presses
set ttyfast                             " Speed up scrolling on vim
set undodir=~/.vim/undodir              " Sets the location of the undo dir.
set undofile                            " Used with plugins. Need for research.
set updatetime=300                      " Increase the update time
set vb t_vb=                            " Disable Beep/Flash
set wildmenu
set wildmode=longest,list               " Get bash-like tab completions
set laststatus=2                        " Always show the status line, even if only one window is displayed
set ofu=syntaxcomplete#Complete         " Enable omnicompletion for syntax
set softtabstop=2                       " Soft tab size
set tabstop=2                           " Tab size
set expandtab                           " Replace tabs with spaces
set shiftwidth=2                        " Visual mode indentation (match tabstop)
set foldmethod=expr                     " Kind of fold used for the current window.
set foldexpr=nvim_treesitter#foldexpr() " Use Treesitter to handle folds

" Syntax
syntax on                       " Enable syntax highlighting

" Python provider configuration
let g:python3_host_prog = '/Users/gmonne/.pyenv/shims/python3'
" Remove Python2 support
let g:loaded_python_provider = 0

" Allow syntax highlighting in markdown
let g:vim_markdown_fenced_languages = ['go', 'html', 'python', 'console=sh', 'bash=sh', 'javascript', 'typescript']

augroup GUX
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
  autocmd BufWritePre *.ts,*.js,*.jsx,*.tsx EslintFixAll
  autocmd BufWritePre *.ts,*.js,*.jsx,*.tsx Prettier
  " Run auto-format on go files.
  autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
  " Remove line numbers in terminal mode.
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd BufLeave term://* stopinsert
  " Syntax highlight
  autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
  autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  " Support comments on JSON files.
  autocmd FileType json syntax match Comment +\/\/.\+$+
  " Auto format lua files.
  autocmd BufWritePre *.lua lua vim.lsp.buf.format(nil, 100)
  " Use 4 spaces for tabs on certain files.
  autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType lua setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  " Reload ultisnip snippets stored in *.snippets folders
  autocmd BufWritePost *.snippets :CmpUltisnipsReloadSnippets
augroup END

" Flash the selection when highlighting.
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

augroup _markdown
  autocmd!
  autocmd FileType markdown setlocal wrap
  autocmd FileType markdown setlocal spell
augroup end

if !exists('*VCenterCursor')
  augroup VCenterCursor
  au!
  au OptionSet *,*.*
    \ if and( expand("<amatch>")=='scrolloff' ,
    \         exists('#VCenterCursor#WinEnter,WinNew,VimResized') )|
    \   au! VCenterCursor WinEnter,WinNew,VimResized|
    \ endif
  augroup END
  function VCenterCursor()
    if !exists('#VCenterCursor#WinEnter,WinNew,VimResized')
      let s:default_scrolloff=&scrolloff
      let &scrolloff=winheight(win_getid())/2
      au VCenterCursor WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
    else
      au! VCenterCursor WinEnter,WinNew,VimResized
      let &scrolloff=s:default_scrolloff
    endif
  endfunction
endif
