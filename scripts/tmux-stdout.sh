#!/usr/bin/env bash

VERSION="0.1.0"

normalize_input() {
	local arg flags

	while [[ $# -gt 0 ]]; do
		arg="$1"
		if [[ $arg =~ ^(--[a-zA-Z0-9_\-]+)=(.+)$ ]]; then
			input+=("${BASH_REMATCH[1]}")
			input+=("${BASH_REMATCH[2]}")
		elif [[ $arg =~ ^(-[a-zA-Z0-9])=(.+)$ ]]; then
			input+=("${BASH_REMATCH[1]}")
			input+=("${BASH_REMATCH[2]}")
		elif [[ $arg =~ ^-([a-zA-Z0-9][a-zA-Z0-9]+)$ ]]; then
			flags="${BASH_REMATCH[1]}"
			for ((i = 0; i < ${#flags}; i++)); do
				input+=("-${flags:i:1}")
			done
		else
			input+=("$arg")
		fi

		shift
	done
}

usage() {
	printf "Copy the last N lines from tmux to the clipboard\n"

	printf "\n\033[4m%s\033[0m\n" "Usage:"
	printf "  %s [OPTIONS]\n" "copy-previous.sh"
	printf "  %s -h|--help\n" "copy-previous.sh"

	printf "\n\033[4m%s\033[0m\n" "Options:"
	printf "  -h --help\n"
	printf "    Print help\n"
}

parse_arguments() {
	while [[ $# -gt 0 ]]; do
		case "${1:-}" in
		-v | --version)
			echo "$VERSION"
			exit
			;;
		-h | --help)
			usage
			exit
			;;
		*)
			break
			;;
		esac
	done
}

main() {
	local temp_file

	temp_file=$(mktemp)

	trap 'rm -f "$temp_file"' EXIT

	tmux capture-pane -p -J -S - -E - >"$temp_file"
	env IN_CAPTURE_PANE=1 nvim +"set ft=bash" "$temp_file"
}

run() {
	declare -a input=()
	normalize_input "$@"
	main "${input[@]}"
}

run "$@"
