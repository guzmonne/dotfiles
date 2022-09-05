#!/usr/bin/env bash

# Get script root folder
ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

# Source history file management script
source "$ROOT/sessionizer-history-file.sh"

# Create history file if it doesn't exist.
history_create_file

session=$(tmux list-sessions | awk '{print $1}' | tr -d ':' |
	fzf \
		--header 'Press CTRL-X to delete a session.' \
		--bind 'ctrl-x:execute-silent(tmux kill-session -t {+})+reload(tmux list-sessions | awk '"'"'{print $1}'"'"' | tr -d ':')')

# Check for the last opened session
previous_session=$(history_get)
if [[ "$previous_session" == "$session" ]]; then
	exit 0
fi

# Save session in history file and keep only TMUX_SESSIONIZER_HISTORY_SIZE lines
history_set "$session"

if ! tmux attach -t "=$session" 2>/dev/null; then
	tmux switch-client -t "=$session"
fi
