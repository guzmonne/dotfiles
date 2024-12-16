# Source the main configuration file.
source "$HOME/.config/zsh/.zshrc"

fpath+=~/.zfunc; autoload -Uz compinit; compinit

zstyle ':completion:*' menu select
