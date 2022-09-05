#!/usr/bin/env bash

# Get script root folder
ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

# Source history file management script
source "$ROOT/sessionizer-history-file.sh"

# Create history file if it doesn't exist.
history_create_file

# Get previous session
session=$(history_get 2)

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
