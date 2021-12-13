# Configure the folder where all zsh configuration will live.
export ZDOTDIR=$HOME/.config/zsh

setopt appendhistory

# Useful zsh options. See man zshoptions
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments

# Remove beep
unsetopt BEEP

# Completitions
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist

# Compinit. Include hidden files.
_comp_options+=(globdots)

autoload -U up-line-or-beggining-search
autoload -U down-line-or-beggining-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N backward-delete-charbindkey
zle -N menuselect
zle -N up-lne-or-history

# Colors
autoload -Uz colors && colors

# Useful functions
# Source: https://github.com/ChristianChiarulli/Machfiles
source "$ZDOTDIR/functions.zsh"

# Normal files to source
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/prompt.zsh"
source "$HOME/.config/zsh/history.zsh"
source "$HOME/.config/zsh/mappings.zsh"
source "$HOME/.config/zsh/completions.zsh"

# Plugins
# More plugins at: https://github.com/unixorn/awesome-zsh-plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
# zsh_add_plugin "sindresorhus/pure"

# Key-bindings
bindkey -s '^n' ' tmux-sessionizer.sh\nclear\n'
bindkey -s '^p' ' tmux-sessions.sh\nclear\n'
bindkey -s '∑' ' tmux-notion.sh\nclear\n'
bindkey -s '^[OP' ' dashdash.sh\nclear\n'
