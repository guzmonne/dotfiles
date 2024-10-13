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
zsh_add_plugin "zsh-users/zsh-history-substring-search"

# Zstyles
# Select completions with arrow keys.
zstyle ':completion:*' menu select
# Group results by category.
zstyle ':completion:*' group-name
# Enable approximate matches.
zstyle ':completion:::::' completer _expand _complete _ignored _approximate


# fzf-tab recommended configuration.
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# TMUX specific configuration
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

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

if command -v mcfly >/dev/null; then
  eval "$(mcfly init zsh)"
fi

# ╭──────────────────────────────────────────────────────────────────────────────╮
# │ NOTE:                                                                        │
# │ You should really make a not to check `man direnv-stdlib` whenever you want  │
# │ to try something new with `direnv`. It's really powerful.                    │
# ╰──────────────────────────────────────────────────────────────────────────────╯
if command -v direnv >/dev/null; then
  eval "$(direnv hook zsh)" > /dev/null 2>&1
fi

# ╭────────────────────────────────────────────────────────────────────────╮
# │ NOTE:                                                                  │
# │ Dasel completions.                                                     │
# │ [Source](https://github.com/TomWright/dasel?utm_source=tldrnewsletter) │
# ╰────────────────────────────────────────────────────────────────────────╯
export fpath=(~/zsh/site-functions $fpath)
mkdir -p ~/zsh/site-functions
dasel completion zsh > ~/zsh/site-functions/_dasel
compinit

if command -v yt >/dev/null; then
  eval "$(yt completion zsh)"
fi

# bun completions
[ -s "/Users/guzmanmonne/.bun/_bun" ] && source "/Users/guzmanmonne/.bun/_bun"

if command -v bedrock > /dev/null; then
  #compdef bedrock

  _bedrock_completion() {
    eval $(env _TYPER_COMPLETE_ARGS="${words[1,$CURRENT]}" _BEDROCK_COMPLETE=complete_zsh bedrock)
  }

  compdef _bedrock_completion bedrock
fi
