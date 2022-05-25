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

# @cmd    Regenerates the SSO profiles.
refresh() {
  if [[ -z getawskeys ]]; then
    echo "You neet to install getawskeys to continue"
    exit 1
  fi

  getawskeys
}

# @cmd    Lists or creates a new secret
# @flag -d --describe Print the full secrets description.
# @arg name Secret name to fetch
# @arg value Secret value
# @arg description Secret description
secrets() {
  if [[ -n "$argc_name" ]]; then
    # Working over a single secret
    if [[ -n "$argc_value" ]]; then
      # Creating a new secret
      aws secretsmanager create-secret \
        --name "$argc_name" \
        --secret-string "$argc_value" \
        $(if [[ -n "$argc_description" ]]; then echo "--description '$argc_description'"; else echo ""; fi)
      exit 0
    fi
    # Reading
    if [[ -n "$argc_describe" ]]; then
      # Reading a secrets metadata
      aws secretsmanager describe-secret --secret-id "$argc_name"
    else
      # Reading a secrets value
      result=$(aws secretsmanager get-secret-value --secret-id "$argc_name")
      if [[ -z "$result" ]]; then
        echo "Secret not found" 2> /dev/stderr
        exit 1
      fi
      secret=$(jq -r ".SecretString" <<<"$result")
      if [[ -z "$secret" ]]; then
        secret=$(jq -r ".SecretBinary" <<<"$result")
      fi
      echo "$secret"
    fi
    exit 0
  fi

  # Working over all secrets
  if [[ -n $argc_describe ]]; then
    aws secretsmanager list-secrets
  else
    aws secretsmanager list-secrets --query='SecretList[].Name' | jq -r '.[]'
  fi
}

# @cmd    Connects to an instance through SSM identified by its `Name` tag.
#         If more than one instance is found with that name a menu will be
#         shown to the user to select the appropriate one.
# @arg    name! Value of the `Name` tag for the instance

# Run argc
eval "$(argc "$0" "$@")"

