#!/usr/bin/env bash

session=$(tmux list-sessions | awk '{print $1}' | tr ":" " " | fzf)

if ! tmux switch-client -t $session 2> /dev/null; then
  tmux attach -t "$session"
fi
