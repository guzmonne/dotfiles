#!/usr/bin/env bash
# This script was generated by rargs 0.0.0 (https://rargs.cloudbridge.uy)
# Modifying it manually is not recommended

if [[ "${BASH_VERSINFO:-0}" -lt 4 ]]; then
  printf "bash version 4 or higher is required\n" >&2
  exit 1
fi

if [[ -n "${DEBUG:-}" ]]; then
  set -x
fi
set -e


parse_root() {

  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      -f | --format)
        rargs_format="$2"
        shift 2
        ;;
      -i | --input)
        rargs_input="$2"
        shift 2
        ;;
      -m | --model)
        rargs_model="$2"
        shift 2
        ;;
      -v | --voice)
        rargs_voice="$2"
        shift 2
        ;;
      -?*)
        printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
        exit 1
        ;;
      *)
        if [[ -z "$rargs_text" ]]; then
          rargs_text=$key
          shift
        else
          printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
          exit 1
        fi
        ;;
    esac
  done
}

root() {
  local rargs_format
  local rargs_input
  local rargs_model
  local rargs_voice
  local rargs_text
  # Parse command arguments
  parse_root "$@"

  
  if [[ -z "$rargs_format" ]]; then
    rargs_format="mp3"
  fi
  if [[ -z "$rargs_input" ]]; then
    rargs_input="-"
  fi
  if [[ -z "$rargs_model" ]]; then
    rargs_model="tts-1"
  fi
  if [[ -z "$rargs_voice" ]]; then
    rargs_voice="nova"
  fi
	# If the text is empty or a dash, read from stdin.
	if [[ -z "$rargs_text" || "$rargs_text" == "-" ]]; then
		text="$(cat)"
	else
		text="$rargs_text"
	fi
	# Print the text to stderr.
	echo "$text" >&2
	curl -s https://api.openai.com/v1/audio/speech -H "Authorization: Bearer $OPENAI_API_KEY" -H "Content-Type: application/json" -d "$(
		jo \
			model="$rargs_model" \
			input="$text" \
			voice="$rargs_voice" \
			format="$rargs_format"
	)" | sox -t "$rargs_format" - -d 2>/dev/null
}


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

inspect_args() {
  prefix="rargs_"
  args="$(set | grep ^$prefix || true)"
  if [[ -n "$args" ]]; then
    echo
    echo args:
    for var in $args; do
      echo "- $var" | sed 's/=/ = /g'
    done
  fi

  if ((${#deps[@]})); then
    readarray -t sorted_keys < <(printf '%s\n' "${!deps[@]}" | sort)
    echo
    echo deps:
    for k in "${sorted_keys[@]}"; do echo "- \${deps[$k]} = ${deps[$k]}"; done
  fi

  if ((${#other_args[@]})); then
    echo
    echo other_args:
    echo "- \${other_args[*]} = ${other_args[*]}"
    for i in "${!other_args[@]}"; do
      echo "- \${other_args[$i]} = ${other_args[$i]}"
    done
  fi
}

version() {
  echo "0.1.0"
}
usage() {
  printf "Utility function to make the terminal speak using OpenAi.\n"
  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  ssh.sh [OPTIONS] [TEXT] \n"
  printf "  ssh.sh -h|--help\n"
  printf "  ssh.sh --version\n"
  printf "\n\033[4m%s\033[0m\n" "Arguments:"
  printf "  TEXT\n"
  printf "    The text to speak.\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -f --format [<FORMAT>]\n"
  printf "    The format to use.\n"
  printf "    [@default mp3]\n"
  printf "  -i --input [<INPUT>]\n"
  printf "    The input text to speak.\n"
  printf "    [@default -]\n"
  printf "  -m --model [<MODEL>]\n"
  printf "    The model to use.\n"
  printf "    [@default tts-1]\n"
  printf "  -v --voice [<VOICE>]\n"
  printf "    The voice to use.\n"
  printf "    [@default nova]\n"
  printf "  -h --help\n"
  printf "    Print help\n"
  printf "  --version\n"
  printf "    Print version\n"
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      --version)
        version
        exit
        ;;
      -h|--help)
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
    -h|--help)
      usage
      exit
      ;;
    "")
      action="nvim"
      ;;
    *)
      action="nvim"
      ;;
  esac
}

run() {
  declare -A deps=()
  declare -a input=()
  normalize_input "$@"
  parse_arguments "${input[@]}"
  root "${input[@]}"
}

run "$@"
