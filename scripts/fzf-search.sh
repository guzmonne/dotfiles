#!/usr/bin/env zsh

# Check to see if a pipe exists on stdin
if [ -p /dev/stdin ]; then
  command=$(cat | sed -E 's/([0-9].*\* )|([0-9].*  )//g' | sort | uniq | fzf --reverse)
else
  echo "No input was found on stdin. Skipping!"
  exit
fi

echo "$command"
eval "$command"


