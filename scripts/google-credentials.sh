#/usr/bin/env bash

# ---
# Script to create a horizontal line.
# Source: https://github.com/LuRsT/hr/blob/master/hr
#
COLS="$(tput cols)"
if (( COLS <= 0 )) ; then
    COLS="${COLUMNS:-80}"
fi

hr() {
  local WORD="$1"
  local LINE=''

  if [[ -z "$WORD" ]] ; then
    return;
  fi

  printf -v LINE '%*s' "$COLS"
  LINE="${LINE// /${WORD}}"
  echo "${LINE:0:${COLS}}"
}

hrs() {
  local WORD

  for WORD in "${@:-#}"
  do
    hr "$WORD"
  done
}
# ---

config=$(gcloud config configurations list | tail -n +2 | awk '{print $1}' | fzf-tmux -p 80%,40% --preview 'gcloud config configurations describe {}')

if [ -z "$config" ]; then exit 0; fi

clear

hrs '─'

gcloud config configurations activate $config

gcloud config configurations describe $config

hrs '─'
