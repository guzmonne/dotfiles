#/usr/bin/env bash

window=$(find ~/Projects -mindepth 1 -maxdepth 2 -type d | fzf)
window_name=$(basename "$window" | tr . _)

if ! tmux has-window -t "$window_name" 2> /dev/null; then
  tmux new-window -n "$window_name" -c "$window" -d
fi

tmux select-window -t "$window_name"

