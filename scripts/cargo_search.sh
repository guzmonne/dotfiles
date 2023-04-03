#!/usr/bin/env bash

if [[ -z $1 ]]; then
  echo "Usage: $0 <search>"
  exit 1
fi

cargo search "$1" --limit 25 | gum choose | pbcopy
