#!/usr/bin/env bash

# Custom alias to make the lua language server work.
alias luamake=/Users/gmonne/Projects/Personal/repos/sumneko/lua-language-server/3rd/luamake/luamake

# Custom aliases.
alias cls="clear"
alias vim="nvim"
alias zconfig="vim ~/.zshrc"
alias zsource="source ~/.zshrc"
alias cat="bat"
alias ls="lsd"
alias ll="ls -alh --color=auto"
alias ctags="`brew --prefix`/bin/ctags"

# Configure tldr to fork in osx.
alias tldr="tldr -p=osx"

# Colorize grep output
alias grep='grep --color=auto'

# Configmr before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Configure Kubernetes aliases
alias k="kubectl"
compdef __start_kubectl k
alias kubeclr='sed -i "" -e "s/^current-context:.*$/current-context:/" ~/.kube/config'
