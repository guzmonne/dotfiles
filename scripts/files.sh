#!/usr/bin/env bash

file=$({
  find ~/OneDrive -type f & \
  find ~/Downloads -type f  & \
  find ~/Documents -type f;
} | cut -c 14- | sort -u | fzf)

if [ -z "$file" ]; then exit 0; fi

open "$HOME$file"
