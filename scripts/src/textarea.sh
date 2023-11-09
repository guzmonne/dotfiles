#!/usr/bin/env bash
# @name textarea
# @version 0.1.0
# @description Use nvim as a textare
# @author Guzmán Monné

set -o pipefail

root() {
	tmpfile="$(mktemp).md"
	trap 'rm -f "$tmpfile"' EXIT

	touch "$tmpfile"
	nvim "$tmpfile" -c "startinsert" >/dev/tty
	if [ ! -s "$tmpfile" ]; then
		# Print error message to stderr
		echo "Error: File is empty." >&2
		rm -f "$tmpfile" # Clean up temp file
		exit 1           # Exit with a non-zero exit code
	fi

	cat "$tmpfile" # If the file is not empty, display its contents
}
