#!/usr/bin/env bash

history_file=${TMUX_SESSIONIZER_HISTORY_FILE:="$HOME/.tmux_sessionizer"}
history_size=${TMUX_SESSIONIZER_HISTORY_SIZE:=10}

# Create the history file
history_create_file() {
  touch "$history_file"
}

# Gets the nth history entry. The index is counted from the newest to the oldest. Meaning that the
# entry with index 0 corresponds to the last session stored on the history file.
#
# Args:
#
#   1: Nth history entry index
#
# Usage:
#
# Get the previous (last) history entry.
#
#   history_get 1
#   # or
#   history_get
#
# Get the oldest history entry.
#
#   history_get -1
#
# Get the entry indexed at the second position.
#
#   history_get 2
#
history_get() {
  if [[ -z "$1" ]]; then
    cat "$history_file" | tail -n 1
    return
  fi
  if [[ "$1" >="$history_size" ]]; then
    cat "$history_file" | head -n 1
    return
  fi
  cat "$history_file" | tail -n "$1" | head -n 1
}

# Appends a new value to the bottom of the history file. It also makes sure that this file doesn't
# have more then history_size lines.
#
# Args:
#
#   1: Value to be appended
#
# Usage:
#
# Set a new value
#
#   history_set "new-entry"
#
history_set() {
  echo "$1" >> "$history_file"
  contents=$(tail -n "$history_size" "$history_file")
  cat <<< "$contents" > "$history_file"
}
