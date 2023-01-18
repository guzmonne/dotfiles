#!/usr/bin/env bash

function tmux_session() {
	tmux display-message -p '#S' | sed "s|$HOME|~|" | sed 's#~/Projects/##' | sed 's#/branches/#  #'
}

function main() {
	echo -e "#[bg=colour214,fg=black] $(tmux_session) 🔸🔷🔸"
}

main
