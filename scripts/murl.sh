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

AWS_DOCS_PROMPT='<system-prompt>
<task>Convert the given HTML document to markdown format</task>
<instructions>
  <step>Remove non-essential HTML elements:
    <sub-step>Remove menus, tabs, navigation links, and similar UI components</sub-step>
    <sub-step>Preserve main content and structure</sub-step>
  </step>
  <step>Convert content to markdown:
    <sub-step>Use # for top-level headings, then start with ## for subsequent levels</sub-step>
    <sub-step>Convert HTML tables to markdown tables</sub-step>
    <sub-step>Convert HTML lists (ordered and unordered) to markdown lists</sub-step>
    <sub-step>Ignore inline styling, focus on content and structure</sub-step>
  </step>
  <step>Handle code-related content:
    <sub-step>Enclose code blocks in triple backticks (```) with appropriate language specification</sub-step>
    <sub-step>Use single backticks (`) for inline code references</sub-step>
  </step>
  <step>If a `Contents` section exists:
    <sub-step>Move it to the top of the document</sub-step>
    <sub-step>Ensure correct links to the referenced sections in the text</sub-step>
  </step>
  <step>For images and other media:
    <sub-step>Preserve the links in markdown format</sub-step>
  </step>
</instructions>
</system-prompt>'

version() {
  echo -n "0.1.0"
}
usage() {
  printf "A simple wrapper that uses curl and mods for multiple purposes.\n"
  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  murl [OPTIONS] [COMMAND] [COMMAND_OPTIONS]\n"
  printf "  murl -h|--help\n"
  printf "  murl -v|--version\n"
  printf "\n\033[4m%s\033[0m\n" "Commands:"
  cat <<EOF
  aws-docs .... Gets an AWS documentation page and formats it as Markdown.
EOF
  printf "  [@default aws-docs]\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -h --help\n"
  printf "    Print help\n"
  printf "  -v --version\n"
  printf "    Print version\n"
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -v|--version)
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
    aws-docs)
      action="aws-docs"
      rargs_input=("${rargs_input[@]:1}")
      ;;
    -h|--help)
      usage
      exit
      ;;
    "")
      action="aws-docs"
      ;;
    *)
      action="aws-docs"
      ;;
  esac
}
aws-docs_usage() {
  printf "Gets an AWS documentation page and formats it as Markdown.\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  aws-docs [OPTIONS] [URL]\n"
  printf "  aws-docs -h|--help\n"
  printf "\n\033[4m%s\033[0m\n" "Arguments:"
  printf "  URL\n"
  printf "    Documentation site URL.\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -a --api [<API>]\n"
  printf "    Mods LLM API to use.\n"
  printf "    [@default anthropic]\n"
  printf "  -m --model [<MODEL>]\n"
  printf "    Mods LLM Model to use.\n"
  printf "    [@default sonnet]\n"
  printf "  -p --prompt [<PROMPT>]\n"
  printf "    AWS Docs LLM prompt.\n"
  printf "  -s --selector [<SELECTOR>]\n"
  printf "    Main selector to filter the body of the curl request.\n"
  printf "    [@default #main-col-body]\n"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_aws-docs_arguments() {
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
      -a | --api)
        rargs_api="$2"
        shift 2
        ;;
      -m | --model)
        rargs_model="$2"
        shift 2
        ;;
      -p | --prompt)
        rargs_prompt="$2"
        shift 2
        ;;
      -s | --selector)
        rargs_selector="$2"
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
        if [[ -z "$rargs_url" ]]; then
          rargs_url=$key
          shift
        else
          printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
          exit 1
        fi
        ;;
    esac
  done
}
# Gets an AWS documentation page and formats it as Markdown.
aws-docs() {
  local rargs_api
  local rargs_model
  local rargs_prompt
  local rargs_selector
  local rargs_url

  # Parse command arguments
  parse_aws-docs_arguments "$@"

  # Rule `no-first-option-help`: Render the global or command usage if the `-h|--help` option is
  #                              is provided anywhere on the command, not just as the first option.
  #                              Handling individual functions case by case.
  if [[ -n "$rargs_help" ]]; then
    aws-docs_usage
    exit 0
  fi
  # Check dependencies
  for dependency in curl pup mods; do
    if ! command -v $dependency >/dev/null 2>&1; then
      printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Missing dependency: " "$dependency" >&2
      exit 1
    fi
  done

  
    
  if [[ -z "$rargs_api" ]]; then
    rargs_api="anthropic"
  fi
    
    
  if [[ -z "$rargs_model" ]]; then
    rargs_model="sonnet"
  fi
    
    
  if [[ -z "$rargs_selector" ]]; then
    rargs_selector="#main-col-body"
  fi
    
	if [[ -z "$rargs_prompt" ]]; then
		rargs_prompt="$AWS_DOCS_PROMPT"
	fi
	curl -skL "$rargs_url" |
		pup "$rargs_selector" |
		mods \
			--api "$rargs_api" \
			--model "$rargs_model" \
			"$rargs_prompt"
}

rargs_run() {
  declare -a rargs_input=()
  normalize_rargs_input "$@"
  parse_arguments "${rargs_input[@]}"
  # Rule `no-first-option-help`: Render the global or command usage if the `-h|--help` option is
  #                              is provided anywhere on the command, not just as the first option.
  #                              Handling the case where no action was selected.
  if [[ -n "$rargs_help" ]] && [[ -z "$action" ]]; then
    usage
    exit 0
  fi
  # Call the right command action
  case "$action" in
    "aws-docs")
      aws-docs "${rargs_input[@]}"
      exit
      ;;
    "")
      aws-docs
      exit
      ;;
    
  esac
}

rargs_run "$@"
