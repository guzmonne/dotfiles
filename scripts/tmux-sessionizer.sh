#/usr/bin/env bash

source ~/.zshrc
session=$(folders.sh)
session_name=$(basename "$session" | tr . _)

if ! tmux has-session -t "$session_name" 2> /dev/null; then
  tmux new-session -s "$session_name" -c "$session" -d
fi

if ! tmux attach -t "$session_name" 2> /dev/null; then
  tmux switch-client -t "$session_name"
fi
