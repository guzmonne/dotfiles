#!/usr/bin/env bash

# Custom aliases.
alias cls="clear"
alias vim="nvim"
alias zconfig="vim ~/.zshrc"
alias zsource="source ~/.zshrc"
alias cat="bat"
alias ls="lsd"
alias ll="ls -alh --color=auto"
alias ctags="`brew --prefix`/bin/ctags"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | xargs -n1 -I {} echo -n {} | pbcopy"

# Configure tldr to fork in osx.
alias tldr="tldr -p=osx"

# Colorize grep output
alias grep='grep --color=auto'

# Confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Configure Kubernetes aliases
alias k="kubectl"
alias kc="kubecolor"
compdef __start_kubectl kubectl
alias kubeclr='sed -i "" -e "s/^current-context:.*$/current-context:/" ~/.kube/config'

# Kitty alias
alias kitty="/Applications/kitty.app/Contents/MacOS/kitty"

# Alias rich to always use thr same template
alias rich="rich --theme=inkpot"

# luamake
alias luamake="$HOME/Projects/Personal/repos/sumneko/lua-language-server/3rd/luamake/luamake"

# Youplot
alias uplot="arch -arm64 youplot"

if command -v gum>/dev/null; then
	alias write="gum write --char-limit 0 --width 90 --height=20"
fi

# The defer function allows for a resource to be cleaned up upon exit of the function or script,
# similar to the defer keyword in Go. This ensures resources are released properly even if the
# script exits early, improving idempotence.
#
# Source: https://cedwards.xyz/defer-for-shell/
#
# Usage:
#   # Mount /tmp as tmpfs and umount it on script exit.
#   mount -t tmpfs tmpfs /tmp
#   defer umount -f /tmp

#   # Create a temporary file and delete it on script exit.
#   TEMP=$(mktemp)
#   echo "Hello!" > "$TEMP"
#   defer rm -f "$TEMP"
DEFER=
defer() {
    DEFER="$*; ${DEFER}"
    trap "{ $DEFER }" EXIT
}
