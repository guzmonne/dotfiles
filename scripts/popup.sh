#!/usr/bin/env bash

alacritty --class popup \
  -o window.dynamic_padding=false \
  -o window.decorations=buttonless \
  -o window.dimensions.columns=180 \
  -o window.dimensions.lines=30 \
  -o window.padding.x=0 \
  -o window.padding.y=0 \
  -o font.offset.y=6 \
  --command "$1"
