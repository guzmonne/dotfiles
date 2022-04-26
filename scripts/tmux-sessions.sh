#!/usr/bin/env bash

session=$(tmux list-sessions | awk '{print $1}' | tr -d ':' |\
  fzf \
    --header 'Press CTRL-X to delete a session.' \
    --bind 'ctrl-x:execute-silent(tmux kill-session -t {+})+reload(tmux list-sessions | awk '"'"'{print $1}'"'"' | tr -d ':')')

if ! tmux attach -t "=$session" 2> /dev/null; then
  tmux switch-client -t "=$session"
fi
