#!/usr/bin/env bash

# Custom aliases.
alias cls="clear"
alias vim="nvim"
alias zconfig="vim ~/.zshrc"
alias zsource="source ~/.zshrc"
alias cat="bat"
# alias ls="lsd"
# alias ll="ls -alh --color=auto"
alias ls="exa"
alias ll="ls -la --icons --group-directories-first --git --no-user"
alias ctags="`brew --prefix`/bin/ctags"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]' | xargs -n1 -I {} echo -n {} | pbcopy"

# Prompt aliases that simplifies copying code from my own prompts and other sites
alias ❯=""
alias $=""

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

# If the gpt.sh script is present, create an alias for gpt4 and claude2.
if [ -f "$HOME/.local/bin/gpt.sh" ]; then
    alias gpt4="gpt.sh"
    alias claude2="gpt.sh -m claude2"
fi

# If jqp is install alias it to use the right theme.
if command -v jqp>/dev/null; then
    alias jqp="jqp -t doom-one2"
fi

# Aliases to use if `c` is installed
if command -v c>/dev/null; then
  alias co='c o --max-tokens=4000 --stream "$(textarea.sh)"'
fi

# Bedrock
alias bedrock-dev="aws --profile bedrock-dev"
alias bedrock-stage="aws --profile bedrock-stage"
alias bedrock-prod="aws --profile bedrock-prod"
alias bedrock-shared="aws --profile bedrock-shared"
alias bedrock-root="aws --profile bedrock-root"

# Terraform 1.4.5
alias tf="AWS_PROFILE=aft-management-admin GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa_canoe -F /dev/null' $HOME/.local/bin/terraform145"

# Jinja2
alias jinja2="$HOME/.pyenv/versions/3.8.18/bin/jinja2"

# E1s
alias e1s-dev="AWS_PROFILE=bedrock-dev e1s"

# Typeos
alias nvmi="nvim"
