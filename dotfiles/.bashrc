# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash"
#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2155

# source "$HOME/.config/zsh/history.zsh"
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/prompt.zsh"
# source "$HOME/.config/zsh/mappings.zsh"
# source "$HOME/.config/zsh/completions.zsh"
# source "$HOME/.config/zsh/autoload.zsh"
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"






[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash"

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
