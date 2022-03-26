#/usr/bin/env bash

session=$(folders.sh)
#session_name=$(basename "$session" | tr . _)
session_name=$(echo "$session" | tr . _ | sed "s|$HOME|~|g")

SESSION_NAME="$session_name" kitty --session ~/.config/kitty/session.conf --title="$session_name"
# if ! tmux has-session -t "$session_name" 2> /dev/null; then
#   tmux new-session -s "$session_name" -c "$session" -d
# fi

# if ! tmux attach -t "$session_name" 2> /dev/null; then
#   tmux switch-client -t "$session_name"
# fi

