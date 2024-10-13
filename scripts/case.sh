#!/usr/bin/env bash

if [[ -n "${DEBUG:-}" ]]; then
	set -x
fi
set -e

normalize_rargs_input() {
	local arg flags

	while [[ $# -gt 0 ]]; do
		arg="$1"
		if [[ $arg =~ ^(--[a-zA-Z0-9_\-]+)=(.+)$ ]]; then
			rargs_input+=("${BASH_REMATCH[1]}")
			rargs_input+=("${BASH_REMATCH[2]}")
		elif [[ $arg =~ ^(-[a-zA-Z0-9])=(.+)$ ]]; then
			rargs_input+=("${BASH_REMATCH[1]}")
			rargs_input+=("${BASH_REMATCH[2]}")
		elif [[ $arg =~ ^-([a-zA-Z0-9][a-zA-Z0-9]+)$ ]]; then
			flags="${BASH_REMATCH[1]}"
			for ((i = 0; i < ${#flags}; i++)); do
				rargs_input+=("-${flags:i:1}")
			done
		else
			rargs_input+=("$arg")
		fi

		shift
	done
}

version() {
	echo -n "1.0.0"
}
usage() {

	printf "\n"
	printf "Run string case conversions.\n"
	printf "\n\033[4m%s\033[0m\n" "Usage:"
	printf "  script [OPTIONS] [COMMAND] [COMMAND_OPTIONS]\n"
	printf "  script -h|--help\n"
	printf "  script -v|--version\n"
	printf "\n\033[4m%s\033[0m\n" "Commands:"
	cat <<EOF
  to-camel .... Converts a string to camel case.
  to-dash ..... Converts a string to dash case.
  to-snake .... Converts a string to snake case.
EOF

	printf "\n\033[4m%s\033[0m\n" "Options:"
	printf "  -h --help\n"
	printf "    Print help\n"
	printf "  -v --version\n"
	printf "    Print version\n"
}

parse_arguments() {
	while [[ $# -gt 0 ]]; do
		case "${1:-}" in
		-v | --version)
			version
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
	action="${1:-}"

	case $action in
	to-camel)
		action="to-camel"
		rargs_input=("${rargs_input[@]:1}")
		;;
	to-dash)
		action="to-dash"
		rargs_input=("${rargs_input[@]:1}")
		;;
	to-snake)
		action="to-snake"
		rargs_input=("${rargs_input[@]:1}")
		;;
	-h | --help)
		usage
		exit
		;;
	"") ;;
	*)
		printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid command: " "$action" >&2
		exit 1
		;;
	esac
}
to-camel_usage() {
	printf "Converts a string to camel case.\n"

	printf "\n\033[4m%s\033[0m\n" "Usage:"
	printf "  to-camel [OPTIONS] [STRING]\n"
	printf "  to-camel -h|--help\n"
	printf "\n\033[4m%s\033[0m\n" "Arguments:"
	printf "  STRING\n"
	printf "    The string to convert.\n"

	printf "\n\033[4m%s\033[0m\n" "Options:"
	printf "  -h --help\n"
	printf "    Print help\n"
}
parse_to-camel_arguments() {
	while [[ $# -gt 0 ]]; do
		case "${1:-}" in
		-h | --help)
			to-camel_usage
			exit
			;;
		*)
			break
			;;
		esac
	done

	while [[ $# -gt 0 ]]; do
		key="$1"
		case "$key" in
		-?*)
			printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
			exit 1
			;;
		*)
			if [[ -z "$rargs_string" ]]; then
				rargs_string=$key
				shift
			else
				printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
				exit 1
			fi
			;;
		esac
	done
}
# Converts a string to camel case.
to-camel() {
	local rargs_string

	# Parse command arguments
	parse_to-camel_arguments "$@"

	to-dash "$rargs_string" | perl -pe 's/-(.)/\u$1/g'
}
to-dash_usage() {
	printf "Converts a string to dash case.\n"

	printf "\n\033[4m%s\033[0m\n" "Usage:"
	printf "  to-dash [OPTIONS] [STRING]\n"
	printf "  to-dash -h|--help\n"
	printf "\n\033[4m%s\033[0m\n" "Arguments:"
	printf "  STRING\n"
	printf "    The string to convert.\n"

	printf "\n\033[4m%s\033[0m\n" "Options:"
	printf "  -h --help\n"
	printf "    Print help\n"
}
parse_to-dash_arguments() {
	while [[ $# -gt 0 ]]; do
		case "${1:-}" in
		-h | --help)
			to-dash_usage
			exit
			;;
		*)
			break
			;;
		esac
	done

	while [[ $# -gt 0 ]]; do
		key="$1"
		case "$key" in
		-?*)
			printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
			exit 1
			;;
		*)
			if [[ -z "$rargs_string" ]]; then
				rargs_string=$key
				shift
			else
				printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
				exit 1
			fi
			;;
		esac
	done
}
# Converts a string to dash case.
to-dash() {
	local rargs_string

	# Parse command arguments
	parse_to-dash_arguments "$@"

	to-snake "$rargs_string" | sed 's|_|-|g'
}
to-snake_usage() {
	printf "Converts a string to snake case.\n"

	printf "\n\033[4m%s\033[0m\n" "Usage:"
	printf "  to-snake [OPTIONS] [STRING]\n"
	printf "  to-snake -h|--help\n"
	printf "\n\033[4m%s\033[0m\n" "Arguments:"
	printf "  STRING\n"
	printf "    The string to convert.\n"

	printf "\n\033[4m%s\033[0m\n" "Options:"
	printf "  -h --help\n"
	printf "    Print help\n"
}
parse_to-snake_arguments() {
	while [[ $# -gt 0 ]]; do
		case "${1:-}" in
		-h | --help)
			to-snake_usage
			exit
			;;
		*)
			break
			;;
		esac
	done

	while [[ $# -gt 0 ]]; do
		key="$1"
		case "$key" in
		-?*)
			printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
			exit 1
			;;
		*)
			if [[ -z "$rargs_string" ]]; then
				rargs_string=$key
				shift
			else
				printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
				exit 1
			fi
			;;
		esac
	done
}
# Converts a string to snake case.
to-snake() {
	local rargs_string

	# Parse command arguments
	parse_to-snake_arguments "$@"

	echo "$rargs_string" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]'
}

rargs_run() {
	declare -a rargs_input=()
	normalize_rargs_input "$@"
	parse_arguments "${rargs_input[@]}"
	# Call the right command action
	case "$action" in
	"to-camel")
		to-camel "${rargs_input[@]}"
		exit
		;;
	"to-dash")
		to-dash "${rargs_input[@]}"
		exit
		;;
	"to-snake")
		to-snake "${rargs_input[@]}"
		exit
		;;
	"")
		printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Missing command. Select one of " "to-camel, to-dash, to-snake" >&2
		usage >&2
		exit 1
		;;

	esac
}

rargs_run "$@"
