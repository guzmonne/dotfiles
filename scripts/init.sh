#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "(dirname "$BASH_SOURCE[0]")" &/dev/null && pwd -P)

usage() {
  tee <<-EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] -d


Initialize a new mac environment

Available options:

-h, --help          Print this help message and exit.
-v, --verbose       Print script debug info.
-d, --directory     Directory where the repo will be downlowded to.
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  echo Running cleanup
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
# flag=0
# param=''
  directory=/Users/gmonne/Projects/Personal

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
#   -f | --flag) flag=1 ;; # example flag
    -d | --directory) 
      directory="${2-}"
      shift
      ;; 
#   -p | --param) # example named parameter
#     param="${2-}"
#     shift
#     ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
# [[ -z "${param-}" ]] && die "Missing required parameter: param"
# [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

parse_params "$@"
setup_colors

# Script logic here
msg "${BLUE} Installing brew:${NOFORMAT}"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

msg "${BLUE} Installing git:${NOFORMAT}"
brew install git

msg "${BLUE} Installing pipx:${NOFORMAT}"
brew install pipx

msg "${BLUE} Installing ansible:${NOFORMAT}"
pipx install ansible

msg "${BLUE} Cloning repository:${NOFORMAT}"
git clone https://github.com/guzmonne/dotfiles $directory

msg "${BLUE} Running setup.yml playbook: ${NOFORMAT}"
ansible-playbook $repo/ansible/setup.yml
