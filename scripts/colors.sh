#!/usr/bin/env bash

word=${1:-Color}

for attrib in $(seq 0 12); do
  for color in $(seq 30 37) $(seq 40 47) $(seq 90 97); do
    printf %b " $attrib $color:\033[$attrib;${color}m$word\033[m"
  done
  printf "\n"
done
