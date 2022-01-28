#!/usr/bin/env bash

word=${1:-Color}
i=0

for attrib in $(seq 0 12); do
  for color in $(seq 30 37) $(seq 40 47) $(seq 90 97); do
    printf %b " $attrib/$color:\033[$attrib;${color}m$word\033[m"
    i=$(($i+1))
    if [[ $(($i % 12)) == 0 ]]; then printf "\n"; fi
  done
done

