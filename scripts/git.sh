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


usage() {
  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  script [OPTIONS] [COMMAND] [COMMAND_OPTIONS]\n"
  printf "  script -h|--help\n"
  printf "\n\033[4m%s\033[0m\n" "Commands:"
  cat <<EOF
  semantic .... Create a semantic git commit from the git diff output.
EOF

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -h --help\n"
  printf "    Print help\n"
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
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
    semantic)
      action="semantic"
      input=("${input[@]:1}")
      ;;
    -h|--help)
      usage
      exit
      ;;
    "")
      ;;
    *)
      printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid command: " "$action" >&2
      exit 1
      ;;
  esac
}
semantic_usage() {
  printf "Create a semantic git commit from the git diff output.\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  semantic [OPTIONS]\n"
  printf "  semantic -h|--help\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_semantic_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -h|--help)
        semantic_usage
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
        if [[ "$key" == "" ]]; then
          break
        fi
        printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
        exit 1
        ;;
    esac
  done
}
# Create a semantic git commit from the git diff output.
semantic() {
  # Parse command arguments
  parse_semantic_arguments "$@"

  diff="$(git diff --staged)"
  if [[ -z "$diff" ]]; then
    echo "No changes to commit."
    return 0
  fi
  cat <<-EOF | c a --stream --model claude2 -
Consider the following text as your guide to creating a semantic git commit from the given 'git diff' output.
Your semantic commit should start with one of these prefixes:
- feat: Introducing a new feature
- fix: Repairing a bug
- docs: Changes solely involving documentation
- style: Modifications that don't impact the underlying code
- refactor: Adjustments to code that don't correct a bug or introduce a new feature
- perf: Modifications to improve performance
- test: The addition of missing tests or correction of existing ones
- build: Alterations affecting the build system or external dependencies
- ci: Revisions to Continuous Integration configuration files and scripts
- chore: Other changes that don't affect source or test files
If a single semantic commit does not precisely categorize the changes, write a list of all required semantic commits.
Above all, try to identify the main service affected by these changes. Include this service in your semantic commit in parentheses. For instance, if changes have been made to the 'sessionizer' service, you should write '(sessionizer)' following the prefix. If you've decided on the 'feat' prefix, the final semantic commit would read as 'feat(sessionizer): ...'.
Begin your response with a '<context></context>' section that highlights all code changes. Next, provide a '<thinking></thinking>' section where you meticulously explain your thought process regarding what needs to be done.
The final section should contain your reply with no superfluous commentary—only the outcome of your reasoning, adhering to the provided guidelines.
Here is the 'git diff' output for your evaluation:
"""
$diff
"""
EOF
}

run() {
  declare -A deps=()
  declare -a input=()
  normalize_input "$@"
  parse_arguments "${input[@]}"
  # Call the right command action
  case "$action" in
    "semantic")
      semantic "${input[@]}"
      exit
      ;;
    "")
      printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Missing command. Select one of " "semantic" >&2
      usage >&2
      exit 1
      ;;
    
  esac
}

run "$@"
