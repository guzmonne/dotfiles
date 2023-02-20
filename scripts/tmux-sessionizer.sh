#!/usr/bin/env bash

# Get script root folder
ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

# Source history file management script
source "$ROOT/sessionizer-history-file.sh"

# Create history file if it doesn't exist.
history_create_file

# Get new session
folder_name=$(folders.sh)
safe_folder_name=$(printf "%s" "$folder_name" | tr '.' '_')

# Check for the last opened session
previous_session=$(history_get)
if [[ "$previous_session" == "$safe_folder_name" ]]; then
	exit 0
fi

# Save session in history file and keep only TMUX_SESSIONIZER_HISTORY_SIZE lines
history_set "$safe_folder_name"

# Create new session if it doesn't exist
if ! tmux has-session -t "=$safe_folder_name" 2>/dev/null; then
	TERM=xterm-256color tmux new-session -s "$safe_folder_name" -c "$folder_name" -d
fi

# Connect to existing session
if ! tmux attach -t "=$safe_folder_name" 2>/dev/null; then
	TERM=xterm-256color tmux switch-client -t "=$safe_folder_name"
fi

