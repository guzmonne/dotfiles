#!/usr/bin/env bash
# shellcheck disable=SC2016
# @describe Handles the GitHub CLI.
# @author Guzmán Monné
# @version 0.1.0

# @cmd Authenticates a different GitHub account
auth() {
  env | grep GITHUB_PAT | cut -d= -f1 | fzf | xargs -I{} bash -c 'gh auth login --with-token <<<"$(echo -n ${})"'
}

eval "$(argc "$0" "$@")"
