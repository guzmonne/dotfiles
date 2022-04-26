#!/usr/bin/env bash

aws_credentials="$HOME/.aws/credentials"

if [[ ! -f "$aws_credentials" ]]; then
  echo "No AWS credentials file found"
  exit 1
fi

profile=$(grep -E '\[' "$aws_credentials" | tr -d '[]' | awk '{print $1}' | fzf)

export AWS_PROFILE="$profile"
export AWS_REGION="us-east-1"
