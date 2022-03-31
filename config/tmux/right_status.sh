#!/usr/bin/env bash

blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
reset="\e[0m"

function tmux_session() {
  tmux display-message -p '#S' | sed "s|$HOME|~|" | sed 's#~/Projects/##' | sed 's#/branches/#  #'
}

function main() {
  echo -e "#[bg=colour214,fg=black] $(tmux_session) 🔸🔷🔸"
}

main
