#!/usr/bin/env bash
# shellcheck disable=SC2016
# @name aws
# @describe Sets the current AWS Profile.
# @author Guzmán Monné
# @version 0.1.0

# @cmd Sets a new AWS Profile
# @option --profile Profile to set
auth() {
  if [[ -z "$rargs_profile" ]]; then
    rargs_profile="$(cat < ~/.aws/credentials | grep -E '^\[.*\]$' | cut -d[ -f2 | cut -d] -f1 | fzf)"
  fi

  # Get the value of the aws_region to use for the selected profile
  region="$(cat < ~/.aws/credentials | grep -E '^\['"$rargs_profile"'.*\]$' -A 3 | grep region | cut -d= -f2 | xargs)"

  echo "export AWS_REGION=$region"
  echo "export AWS_PROFILE=$rargs_profile"
}

