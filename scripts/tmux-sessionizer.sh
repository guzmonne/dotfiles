#/usr/bin/env bash

session_name=$(folders.sh)

if ! tmux has-session -t "$session_name" 2> /dev/null; then
  tmux new-session -s "$session_name" -c "$session_name" -d
fi

if ! tmux attach -t "$session_name" 2> /dev/null; then
  tmux switch-client -t "$session_name"
fi
