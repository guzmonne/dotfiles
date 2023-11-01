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
  printf "A simple wrapper build around ollama\n"
  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  ollama [OPTIONS] [COMMAND] [COMMAND_OPTIONS]\n"
  printf "  ollama -h|--help\n"
  printf "  ollama --version\n"
  printf "\n\033[4m%s\033[0m\n" "Commands:"
  cat <<EOF
  generate .... Runs ollama against the given model
EOF
  printf "  [@default run]\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -v --verbose\n"
  printf "    Enable verbose output.\n"
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
      *)
        break
        ;;
    esac
  done
  action="${1:-}"

  case $action in
    generate)
      action="generate"
      input=("${input[@]:1}")
      ;;
    -h|--help)
      usage
      exit
      ;;
    "")
      action="run"
      ;;
    *)
      action="run"
      ;;
  esac
}
generate_usage() {
  printf "Runs ollama against the given model\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  generate -m|--model <MODEL> [OPTIONS] PROMPT\n"
  printf "  generate -h|--help\n"
  printf "\n\033[4m%s\033[0m\n" "Arguments:"
  printf "  PROMPT\n"
  printf "    The prompt to use\n"
  printf "    [@required]\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -m --model <MODEL>\n"
  printf "    The model to run\n"
  printf "  -v --verbose\n"
  printf "    Enable verbose output.\n"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_generate_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      *)
        break
        ;;
    esac
  done

  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      -v | --verbose)
        rargs_verbose=1
        shift
        ;;
      -m | --model)
        rargs_model="$2"
        shift 2
        ;;
      -h|--help)
        rargs_help=1
        shift 1
        ;;
      -?*)
        printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
        exit 1
        ;;
      *)
        if [[ -z "$rargs_prompt" ]]; then
          rargs_prompt=$key
          shift
        else
          printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
          exit 1
        fi
        ;;
    esac
  done
}
# Runs ollama against the given model
generate() {
  local rargs_verbose
  local rargs_model
  local rargs_prompt
  # Parse command arguments
  parse_generate_arguments "$@"

  # Rule `no-first-option-help`: Render the global or command usage if the `-h|--help` option is
  #                              is provided anywhere on the command, not just as the first option.
  #                              Handling individual functions case by case.
  if [[ -n "$rargs_help" ]]; then
    generate_usage
    exit 0
  fi
  
  if [[ -z "$rargs_model" ]]; then
    printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Missing required option: " "model" >&2
    generate_usage >&2
    exit 1
  fi
  if [[ -z "$rargs_prompt" ]]; then
    printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Missing required option: " "prompt" >&2
    generate_usage >&2
    exit 1
  fi
  if [[ "$rargs_prompt" == "-" ]]; then
    rargs_prompt="$(cat -)"
  fi
  curl -N -sX POST "http://localhost:11434/api/generate" -d "$(jo \
    model="$rargs_model" \
    prompt="$rargs_prompt" \
  )" | while read -r line; do
    if [[ -z "$line" ]]; then
      continue
    fi
    eval printf "%s" "$(jq '.response' <<<"$line" | grep -v '^null$' | perl -pe 's/\\n/\n/g')"
  done
}

run() {
  declare -A deps=()
  declare -a input=()
  normalize_input "$@"
  parse_arguments "${input[@]}"
  # Rule `no-first-option-help`: Render the global or command usage if the `-h|--help` option is
  #                              is provided anywhere on the command, not just as the first option.
  #                              Handling the case where no action was selected.
  if [[ -n "$rargs_help" ]] && [[ -z "$action" ]]; then
    usage
    exit 0
  fi
  # Call the right command action
  case "$action" in
    "generate")
      generate "${input[@]}"
      exit
      ;;
    "")
      run
      exit
      ;;
    
  esac
}

run "$@"
