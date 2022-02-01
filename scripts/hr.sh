#!/usr/bin/env bash

# Script to create a horizontal line this size of the window.
# You can select which symbol to use for the line at runtime
# @example
# ```sh
# hr.sh '─'
# ```
COLS="$(tput cols)"
if (( COLS <= 0 )) ; then
    COLS="${COLUMNS:-80}"
fi

hr() {
  local WORD="$1"
  local LINE=''

  if [[ -z "$1" ]] ; then
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

hrps() {
  block100="\xe2\x96\x87"  # u2588\0xe2 0x96 0x88 Solid Block 100%
  block75="\xe2\x96\x93"   # u2593\0xe2 0x96 0x93 Dark shade 75%
  block50="\xe2\x96\x92"   # u2592\0xe2 0x96 0x92 Half shade 50%
  block25="\xe2\x96\x91"   # u2591\0xe2 0x96 0x91 Light shade 25%

  blockAsc="$(printf -- '%b\n' "${block25}${block50}${block75}")"
  blockDwn="$(printf -- '%b\n' "${block75}${block50}${block25}")"
  # Figure out the width of the terminal window
  local width="$(( "${COLUMNS:-$(tput cols)}" - 6 ))"
  # Define our initial color code
  local color="${1:-1}"
  tput setaf "${color}"               # Set our color
  printf -- '%s' "${blockAsc}"        # Print the ascending block sequence
  for (( i=1; i<=width; ++i )); do    # Fill the gap with hard blocks
    printf -- '%b' "${block100}"
  done
  printf -- '%s\n' "${blockDwn}"      # Print our descending block sequence
  tput sgr0
}

function usage() {
  echo "$0 [-c|--color-block|-h|--help] [COLOR|SYMBOL]"
  echo
  echo "  -c|--color-block [COLOR]     create a block horizontal line of the provided color"
  echo "  -h|--help                    show this help text"
  echo "  [SYMBOL]                     prints an horizontal line using the provided symbol"
}

color_block=0
positional=()

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -h|--help) usage; exit;;
    -c|--color-block) color_block=1;shift;;
    *) positional+=("$1");shift;;
  esac
done

set -- "${positional[@]}"

if [[ "$color_block" == 1 ]]; then
  hrps "$@"
else
  hrs "$@"
fi
