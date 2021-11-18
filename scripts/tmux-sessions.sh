#!/usr/bin/env bash

session=$(tmux list-sessions | awk '{print $1}' | tr -d ":" | fzf)

if ! tmux attach -t "$session" 2> /dev/null; then
  tmux switch-client -t "$session"
fi
