#!/usr/bin/env bash

# Get script root folder
ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

# Source history file management script
source "$ROOT/tmux-sessionizer-history-file.sh"

# Create history file if it doesn't exist.
history_create_file

# List and get the requested history entry
session=$(
	history_list |
		fzf \
			--header 'Press CTRL-X to delete a session.' \
			--bind 'ctrl-x:execute-silent(tmux kill-session -t {+})+reload(tmux list-sessions | awk '"'"'{print $1}'"'"' | tr -d ':')'
)

# Check for the last opened session
current_session=$(history_get)
if [[ "$session" == "$current_session" ]]; then
	exit 0
fi

# Save session in history file and keep only TMUX_SESSIONIZER_HISTORY_SIZE lines
history_set "$session"

if ! tmux attach -t "=$session" 2>/dev/null; then
	tmux switch-client -t "=$session"
fi
