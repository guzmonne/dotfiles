#!/usr/bin/env bash

function tmux_session() {
  tmux display-message -p '#S' | sed "s|$HOME|~|" | sed 's#~/Projects/##' | sed 's#/branches/#  #'
}

function main() {
  echo -e "#[fg=colour214,bg=#1a1b26] $(tmux_session) 🔸🔷🔸"
}

main
