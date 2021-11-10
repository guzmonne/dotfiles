#/usr/bin/env bash

window=$(folders.sh)
window_name=$(basename "$window" | tr . _)

if ! tmux has-window -t "$window_name" 2> /dev/null; then
  tmux new-window -n "$window_name" -c "$window" -d
fi

TERM=xterm-256color tmux select-window -t "$window_name"

