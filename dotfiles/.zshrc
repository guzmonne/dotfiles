# Source z
# You need to run the clone.yml file to be able to use this.
# ```sh
# ansible-playbook ansible/clone.yml --extra-vars="root=`pwd`"
# ```
source ~/.config/repos/rupa/z/z.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source zsh-autocomplete repo
# source /Users/gmonne/.config/repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# Customize zsh-autocomplete configuration
# zstyle ':autocomplete:*' min-delay 1.0
# zstyle ':autocomplete:*' min-input 3
# zstyle ':autocomplete:*' fzf-completion yes

# Path to your oh-my-zsh installation.
export ZSH="/Users/gmonne/.oh-my-zsh"

#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

export POWERLEVEL9K_INSTANT_PROMPT=off

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# ZSH-Completion configuration
autoload -U compinit && compinit

# User configuration

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Configure default ansible config file
export ANSIBLE_CONFIG=~/.ansible.cfg

# Color man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# PATH
export PATH=$PATH:/Users/gmonne/.cargo/bin
export PATH=$PATH:/Users/gmonne/.local/bin

# Configure completions for pipx
eval "$(register-python-argcomplete pipx)"

# Configure zsh key mappings using the escape key as leader
bindkey -s '^n' 'tmux-sessionizer.sh\n'
bindkey -s '^p' 'tmux-sessions.sh\n'
bindkey -s '∑' 'tmux-notion.sh\n'
bindkey -s '^[OP' 'dashdash.sh\n'

# Local bin path
export PATH=$PATH:/Users/gmonne/.local/bin

# Fix perl locale issue
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Fix OpenSSL link issue
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/gmonne/.local/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/gmonne/.local/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/gmonne/.local/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/gmonne/.local/google-cloud-sdk/completion.zsh.inc'; fi

# Add gcloud to the global path
export PATH=$PATH:"/Users/gmonne/.local/google-cloud-sdk/bin"

# Add n to the global path and configure N_PREFIX
export PATH=$PATH:"/Users/gmonne/.local/n/bin"
export N_PREFIX="/Users/gmonne/.local/n/versions"

# Configure Perl path
PATH="/Users/gmonne/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/Users/gmonne/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/gmonne/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/gmonne/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/gmonne/perl5"; export PERL_MM_OPT;

# Configure `fd` to work nicely with `fzf`.
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="--color=bg+:#292e42,spinner:#bb9af7,hl:#565f89,fg:#c0caf5,header:#565f89,info:#7dcfff,pointer:#bb9af7,marker:#7dcfff,fg+:#c0caf5,preview-bg:#1f2335,prompt:#bb9af7,hl+:#bb9af7"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Configure colors using `vivid`
export LS_COLORS="$(vivid generate tokyonight)"

# Custom aliases
alias luamake=/Users/gmonne/Projects/Personal/repos/sumneko/lua-language-server/3rd/luamake/luamake
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias cls="clear"
alias vim="nvim"
alias zconfig="vim ~/.zshrc"
alias zsource="source ~/.zshrc"
alias cat="bat"
alias ls="lsd"
alias ll="ls -alh --color=auto"
alias ctags="`brew --prefix`/bin/ctags"
alias tmux="TERM=xterm-256color tmux"
alias tldr="tldr -p=osx"
alias node=$(n which lts || which node)
alias ssh="TERM=xterm-256color ssh"

