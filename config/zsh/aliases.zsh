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
	# alias glow="glow -s $HOME/.config/glow/style.json"
fi

function bbb() {
	if [ -z "$1" ]; then
		echo "Please provide a session name"
		return 1
	fi

	session="$1"
	shift

	if [[ "$1" == "edit" ]]; then
		gpt.sh edit "$HOME/.b/sessions/$session"
		return 0
	fi

	if [[ "$1" == "-" ]]; then
		b chats create --session "$session" - <"/dev/stdin" | glow
		return $?
	fi

	if [ -z "$1" ]; then
		write --placeholder="Enter your message for $session..." | b chats create --session "$session" - | glow
	else
		echo -n "$@" | b chats create --session "$session" - | glow
	fi
}

# ChatGPT Aliases
if command -v b>/dev/null; then
	function awsy() { bbb awsy "$@" }
	function rusty() { bbb rusty "$@" }
	function kuby() { bbb kuby "$@" }
	function javy() { bbb javy "$@" }
	function bashy() { bbb bashy "$@" }
	function releasy() { bbb releasy "$@" }
	function vimy() { bbb vimy "$@" }
fi
