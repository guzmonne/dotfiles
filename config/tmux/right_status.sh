#!/usr/bin/env bash

function tmux_session() {
  tmux display-message -p '#S' | sed "s|$HOME|~|" | sed 's#~/Projects/##' | sed 's#/branches/#  #'
}

# Get the battery level of the computer.
function battery() {
  level="$(echo -e "$(pmset -g batt | grep -o '[0-9]\{1,3\}%')" | sed 's/%//')"

  # If level is above 50 the color should be green.
  # If level is below 50 the color should be yellow.
  # If level is below 20 the color should be red.
  if [ $level -gt 50 ]; then
    echo -e "#[fg=colour10]⚡️$level"
  elif [ $level -gt 20 ]; then
    echo -e "#[fg=colour11]⚡️$level"
  else
    echo -e "#[fg=colour9]⚡️$level"
  fi
}

function main() {
  if test -n "$SSH_CLIENT"; then
    echo -e "#[fg=colour12,bg=#1a1b26] $(tmux_session) 🔷🔸🔷 $(battery) "
  else
    echo -e "#[fg=colour214,bg=#1a1b26] $(tmux_session) 🔸🔷🔸"
  fi
}

main
