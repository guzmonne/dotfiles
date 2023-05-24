#!/usr/bin/env bash

# @describe CLI Spinner

# @cmd    Starts a new spinner
# @alias  s
# @option -i --interval=0.10 frame interval
# @option -f --frames=⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏ Spinner frames
start()  {
  tput civis -- invisible

  pid=$! # Process Id of the previous running command

  i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(((i + 1) % ${#argc_frames}))
    printf "\r${argc_frames:i:1}"
    sleep .1
  done

  tput cnorm   -- normal
}

# Run argc
eval "$(argc $0 "$@")"
