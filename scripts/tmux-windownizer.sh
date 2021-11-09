#/usr/bin/env bash

window=$(folders.sh)
window_name=$(basename "$window" | tr . _)

if ! tmux has-window -t "$window_name" 2> /dev/null; then
  tmux new-window -n "$window_name" -c "$window" -d
fi

tmux select-window -t "$window_name"

