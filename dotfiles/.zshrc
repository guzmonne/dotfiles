# Source the main configuration file.
source "$HOME/.config/zsh/.zshrc"

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc



[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
