#!/usr/bin/env bash

aws_config="$HOME/.aws/config"

if [[ ! -f "$aws_config" ]]; then
  echo "No AWS configuration file found"
  exit 1
fi

profile=$(grep -E '\[' "$aws_config" | tr -d '[]' | awk '{print $2}' | fzf)

export AWS_PROFILE="$profile"
export AWS_REGION="us-east-1"

aws sso login
