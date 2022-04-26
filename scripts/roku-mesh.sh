#!/usr/bin/env bash

# @describe Common Roku Mesh commands

# Helper functions.
green() {
  printf "${FG_GREEN}${FS_REG}$@${RESET_ALL}"
}

yellow() {
  printf "${FG_YELLOW}${FS_REG}$@${RESET_ALL}"
}

red() {
  printf "${FG_RED}${FS_REG}$@${RESET_ALL}"
}

# @cmd list all the namespaces available.
available_namespaces() {
  if [ -z "$(which az)" ]; then
    red You need to install azure-cli to run this command
    echo
    exit
  fi
  az ad user get-member-groups --id "$USER"@roku.com 2> /dev/null | grep "sg-sso-aws" | tr -d '",' | awk '{print $2}'
}

# @cmd change the current Roku Mesh context
# @option -p --path=Projects/Roku/rokumesh-sandbox.git/branches/master rokumesh-sandbox_git project repository path relative to $HOME
# @option -c --context context name
change_context() {
  if [ -z "$argc_context" ]; then
    argc_context=$(available_namespaces | fzf)
  fi
  "$HOME"/"$argc_path"/public/scripts/sandbox-kconfig.sh -g "$argc_context"
}

# @cmd prints the list of available groups you have access to
groups() {
  check_context
  kubectl get ns | grep "group--"
}

# Makes sure you are connected to the correct context
check_context() {
  if [ "$(kubectl config current-context 2> /dev/null || true)" != "rokumesh-sandbox:us-west-2" ]; then
    red You need to be working on the rokumesh sandbox for this to work
    echo
    exit
  fi
}

# @cmd check if you have permissions to create certain tasks on the sandbox
# @option -g --group group over which you want to check for permissions
# @arg action="create deployment" action to check for permissions
can_i() {
  check_context
  if [ -z "$argc_group" ]; then
    argc_group=$(groups | fzf | awk '{print $1}')
  fi
  command="kubectl auth can-i $argc_action -n $argc_group"
  echo "$command"
  eval "$command"
}

# Run argc
eval "$(argc "$0" "$@")"
