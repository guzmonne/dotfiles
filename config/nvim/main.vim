unlet! skip_defaults_vim
runtime defaults.vim

" Filetype
filetype on
filetype plugin on
filetype indent on

set cursorline                             " Highlight the current line
set emoji                                  " Fix emoji display
set autoindent                             " Inherit indentation from previous line.
set autoread                               " Reload the file when external changes are detected
set autowriteall                           " Work with buffers
set backspace=indent,eol,start             " Fixes common backspace problems.
set cc=100,120                             " Set a 100 and 120 column border
set cindent
set clipboard=unnamedplus                  " Using system clipboard
set cmdheight=0                            " Give more space for displaying messages
set completeopt=menu,menuone,noselect      " Make the completion menu behave like an IDE
set conceallevel=0                         " Makes `` visible on markdown files.
set confirm                                " Makes it easier to
set exrc                                   " Source coniguration every time I enter a new project
set encoding=utf-8                         " Set encoding to utf-8
set fileencoding=utf-8                     " Use utf-8 as encoding type for files.
set guicursor=                             " Set the guicursor to always be a block
set hidden                                 " Keeps any buffer available
set hlsearch                               " Highlight search
set incsearch                              " Incremental search
set matchpairs+=<:>                        " Highlight matching pairs of branckets.
set mouse=a                                " Enable mouse click
set nobackup                               " Don't backup files
set nocompatible                           " Disable compatibility to old-time vi
set noerrorbells                           " Disable error bells sounds
set nofoldenable                           " Deactivate fold use command.
set belloff=all                            " Disable all system bells
set nohlsearch                             " Hide the search highlight after present enter
set noignorecase                           " Case sensitive searches
set noshowmode                             " Remove --INSERT-- and similar text from the message line.
set noswapfile                             " Disable the use of swapfiles
set nowrap                                 " Disable line wraping
set nowritebackup                          " Don't write backups.
set number                                 " Add line numbers
set numberwidth=4                          " Set number width to 4 (default: 2)
set pumheight=10                           " Pop up menu height
set re=0                                   " Stop old regex engine to avoid performance loss.
set relativenumber                         " Un-set relative numbers
set ruler                                  " Enable line and column display
set scrolloff=8                            " Make vim start scrolling 8 lines from the end
set shortmess=F                            " Don't pass messages to |ins-completion-menu|
set showmatch                              " Show matching
set signcolumn=yes                         " Show sign column.
set nosmartindent                          " Don't use VIM smart indentation.
set splitbelow                             " Split panes to the bottom
set splitright                             " Split panes to the right
set termguicolors                          " Use terminal GUI colors.
set timeoutlen=500                         " Update the time between multiple key presses
set ttyfast                                " Speed up scrolling on vim
set undodir=~/.vim/undodir                 " Sets the location of the undo dir.
set undofile                               " Used with plugins. Need for research.
set updatetime=50                          " Increase the update time
set vb t_vb=                               " Disable Beep/Flash
set wildmenu                               " Better CMP menu.
set wildmode=longest,list                  " Get bash-like tab completions
set laststatus=2                           " Show global statusline
set ofu=syntaxcomplete#Complete            " Enable omnicompletion for syntax
set softtabstop=2                          " Soft tab size
set tabstop=2                              " Tab size
set expandtab                              " Replace tabs with spaces
set shiftwidth=2                           " Visual mode indentation (match tabstop)
set foldmethod=expr                        " Kind of fold used for the current window.
set foldexpr=nvim_treesitter#foldexpr()    " Use Treesitter to handle folds
set pumblend=15                            " Enable pseudo-transparency on pop-up windows.
set winblend=15                            " Enable pseudo-transparency for a floating window.
set textwidth=100                          " Set text width to 80
set wrapmargin=2                           " Set wrap margin to 2
set wildignore+=*/node_modules/*           " Ignore node_modules

" Remove background on all windows.
hi PmenuSel blend=0
hi Normal guibg=none ctermbg=none
hi LineNr guibg=none ctermbg=none
hi Folded guibg=none ctermbg=none
hi NonText guibg=none ctermbg=none
hi SpecialKey guibg=none ctermbg=none
hi VertSplit guibg=none ctermbg=none
hi SignColumn guibg=none ctermbg=none
hi EndOfBuffer guibg=none ctermbg=none

" Change color of the cursor line
highlight CursorLine ctermbg=none guibg=#0f0f0f gui=NONE cterm=NONE

" Python provider configuration
let g:python3_host_prog = '/Users/guzmanmonne/miniconda/bin/python'
" Remove Python2 support
let g:loaded_python_provider = 0
" Remove Ruby provider
let g:loaded_ruby_provider = 0
" Remove Perl provider
let g:loaded_perl_provider = 0

" Disable netrw
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Disable default GitGutter mappings
let g:gitgutter_map_keys = 0
" Configure editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
" Configure Markdown Preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
" Configure md
let g:md_fenced_languages = ['shell', 'html', 'typescriptreact', 'json', 'jsonc', 'yaml', 'ts=typescript', 'typescript', 'sh', 'bash', 'sql', 'console=sh', 'javascript', 'js=javascript', 'json=javascript']

" Try to disable SQLComplete Something
let g:omni_sql_no_default_maps = 1

" Configure vim-illuminate
let g:Illuminate_useDeprecated = 0
let g:Illuminate_delay = 0
let g:Illuminate_ftblacklist = ['fugitive', 'oil']

augroup GUX
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
  " autocmd BufWritePre *.ts,*.js,*.jsx,*.tsx EslintFixAll
  autocmd BufWritePre *.ts,*.js,*.jsx,*.tsx Prettier
  " Run auto-format.
  autocmd BufWritePre *.sh lua vim.lsp.buf.format({ async = true })
  autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = true })
  autocmd BufWritePre *.lua lua vim.lsp.buf.format({ async = true }, 100)
  autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })
  " Remove line numbers in terminal mode.
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd BufLeave term://* stopinsert
  " Support comments on JSON files.
  autocmd FileType json syntax match Comment +\/\/.\+$+
  " Use 4 spaces for tabs on certain files.
  autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType lua setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType rust setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd BufWritePost python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd BufWritePost lua setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  autocmd BufWritePost rust setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
  " Terraform format
  autocmd BufWritePre *.tfvars lua vim.lsp.buf.format({ async = true })
  autocmd BufWritePre *.tf lua vim.lsp.buf.format({ async = true })
  " Flash the selection when highlighting.
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  " Disable diagnostics in node modules (0 is current buffer only)
  autocmd BufRead */node_modules/* :lua vim.lsp.diagnostic.disable(0)
  autocmd BufNewFile */node_modules/* :lua vim.lsp.diagnostic.disable(0)

  " Vim-Illuminate highlight configuration
  autocmd VimEnter * hi link illuminatedWord CursorLine
  autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
  autocmd VimEnter * hi illuminatedCurWord cterm=italic gui=italic

  " Cursorline transparency
  autocmd ColorScheme * highlight CursorLine guibg=#0f0f0f ctermbg=none

  " Jinja Highlight
  au BufNewFile,BufRead *.tera set ft=jinja
augroup END
