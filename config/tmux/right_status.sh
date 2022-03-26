#!/usr/bin/env bash

# function main() {
#   echo -n "🗓  $(date)"
# }

blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
reset="\e[0m"

function tmux_session() {
  tmux display-message -p '#S' | sed 's#~/Projects/##' | sed 's#/branches/#  #'
}

function main() {
  echo -e "#[fg=colour214]#[bg=colour214,fg=black] $(tmux_session) 🔷"
}

main
