#!/usr/bin/env bash

# @describe Custom functions for the AWS cli.

# @cmd    Connects to an instance through SSM identified by its `Name` tag.
#         If more than one instance is found with that name a menu will be
#         shown to the user to select the appropriate one.
# @arg    name! Value of the `Name` tag for the instance
ssm() {
  tmpfile=$(mktemp)
  # create file descriptor 3 for writing to a temporary file so that
  # echo ... >&3 writes to that file
  exec 3>"$tmpfile"

  echo $(aws ec2 describe-instances \
    --filter "Name=tag:Name,Values=$argc_name" --query 'Reservations[*].Instances[*]' \
  ) >&3
  instances_length=$(cat "$tmpfile" | jq '. | length')

  if [[ "$instances_length" -eq 0 ]]; then
    echo "No instances were found named $argc_name"
    exit 1
  elif [[ "$instances_length" -gt 1 ]]; then
    instances_ids=$(cat "$tmpfile" | jq -r '(.[][].InstanceId)')
    instance_id=$(echo "$instances_ids" | fzf -d" " --preview "cat $tmpfile | jq '.[][] | select(.InstanceId | contains(\"{}\"))'")
  else
    instance_id=$(cat "$tmpfile" | jq -r '(.[0][0].InstanceId)')
  fi
  aws ssm start-session --target "$instance_id"
}

# Run argc
eval "$(argc "$0" "$@")"

