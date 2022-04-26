#!/usr/bin/env bash

# @describe Configure SSO

aws_credentials="$HOME/.aws/credentials"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    help|h)
      echo "Roku AWS SSO helper"
      echo
      echo "Usage:"
      echo "------"
      echo
      echo "$0 SUBCOMMAND"
      echo
      echo "Subcommands:"
      echo "------------"
      echo
      echo "login ........ avoid going through the SSO flow"
      echo "profiles ..... show the list of available profiles"
      echo "help ......... show this help message"
      echo
      exit;;
    login|l)
      if [[ ! -f "$aws_credentials" ]]; then
        echo "No AWS credentials file found"
        exit 1
      fi
      getawskeys
      exit;;
    profiles|p)
      grep -E '\[' "$aws_credentials" | tr -d '[]' | awk '{print $1}' | fzf-tmux -p 40%,30%
      exit;;
    *)
      positional+=("$1")
      shift;;
  esac
done

