#/usr/bin/env bash

session=$(find ~/Projects -mindepth 1 -maxdepth 2 -type d | fzf)
session_name=$(basename "$session" | tr . _)

if ! tmux has-session -t "$session_name" 2> /dev/null; then
  tmux new-session -s "$session_name" -c "$session" -d
fi

tmux attach -t "$session_name"
