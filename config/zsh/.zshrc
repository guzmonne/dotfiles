# Configure the folder where all zsh configuration will live.
export ZDOTDIR=$HOME/.config/zsh

# Add brew bin path
export PATH=/opt/homebrew/bin:$PATH

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
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/gmonne/.config/zsh/.zshrc'

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit
# End of lines added by compinstall
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

# Add support for interactive comments
setopt INTERACTIVE_COMMENTS

# Colors
autoload -Uz colors && colors

# Useful functions
# Source: https://github.com/ChristianChiarulli/Machfiles
source "$ZDOTDIR/functions.zsh"

# Plugins
# More plugins at: https://github.com/unixorn/awesome-zsh-plugins
zsh_add_plugin "lukechilds/zsh-nvm"
zsh_add_plugin "Aloxaf/fzf-tab"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-completions"
zsh_add_plugin "zdharma-continuum/fast-syntax-highlighting"
zsh_add_plugin "hlissner/zsh-autopair"
zsh_add_plugin "buonomo/yarn-completion"
zsh_add_plugin "lukechilds/zsh-better-npm-completion"
zsh_add_plugin "mattberther/zsh-pyenv"
zsh_add_plugin "zsh-users/zsh-history-substring-search"

# Normal files to source
source "$HOME/.config/zsh/history.zsh"
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/prompt.zsh"
source "$HOME/.config/zsh/mappings.zsh"
source "$HOME/.config/zsh/completions.zsh"
source "$HOME/.config/zsh/autoload.zsh"

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

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/guzmanmonne/miniconda/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/guzmanmonne/miniconda/etc/profile.d/conda.sh" ]; then
        . "/Users/guzmanmonne/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/Users/guzmanmonne/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

