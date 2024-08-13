# Disable ctrl-s and ctrl-q
stty -ixon

setopt appendhistory

# Useful zsh options. See man zshoptions
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
# Automatically list choices on ambiguous completion.
setopt auto_list
# Automatically use menu completion.
setopt auto_menu
# Move cursor to end if word has one match.
setopt always_to_end
# Force the user to type exit or logout instead of pressing Ctrl-D.
setopt ignoreeof

# Remove beep
unsetopt BEEP

# Completitions
# Lines configured by zsh-newuser-install
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v

zstyle ':completion:*' menu select
zmodload zsh/complist

# Compinit. Include hidden files.
_comp_options+=(globdots)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N backward-delete-charbindkey
zle -N menuselect
zle -N up-lne-or-history

# Add support for interactive comments
setopt INTERACTIVE_COMMENTS

# Colors
autoload -Uz colors && colors

# Useful functions
# Source: https://github.com/ChristianChiarulli/Machfiles
source "$HOME/.config/zsh/functions.zsh"
source "$HOME/.config/zsh/git.zsh"

# Plugins
# More plugins at: https://github.com/unixorn/awesome-zsh-plugins
zsh_add_plugin "Aloxaf/fzf-tab"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "zdharma-continuum/fast-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "zsh-users/zsh-history-substring-search"

# Zstyles
# Select completions with arrow keys.
zstyle ':completion:*' menu select
# Group results by category.
zstyle ':completion:*' group-name
# Enable approximate matches.
zstyle ':completion:::::' completer _expand _complete _ignored _approximate


# fzf-tab recommended configuration.
# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# Switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# Remove path duplicates
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

# Enable McFly
eval "$(mcfly init zsh)"

# Normal files to source
source "$HOME/.config/zsh/history.zsh"
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/mappings.zsh"
source "$HOME/.config/zsh/autoload.zsh"
source "$HOME/.config/zsh/prompt.zsh"

autoload bashcompinit && bashcompinit
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

if which aws_completer > /dev/null 2>&1; then
  complete -C '/usr/local/bin/aws_completer' aws
fi

if [ -f "${HOME}/.local/google-cloud-sdk/completion.zsh.inc" ]; then
  source "${HOME}/.local/google-cloud-sdk/completion.zsh.inc"
fi

eval "$(mcfly init zsh)"

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ NOTE:                                                                        │
# │ You should really make a not to check `man direnv-stdlib` whenever you want  │
# │ to try something new with `direnv`. It's really powerful.                    │
# ╰──────────────────────────────────────────────────────────────────────────────╯
eval "$(direnv hook zsh)"
