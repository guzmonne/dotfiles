#!/usr/bin/env bash
# Closes all windows and spaces managed by yabai

windows="$(yabai -m query --windows | jq '.[] | .id')"

for window in $windows; do
	yabai -m window --close "$window" >/dev/null
done

spaces="$(yabai -m query --spaces | jq '.[] | .index')"

for space in $spaces; do
	yabai -m space "$space" --destroy >/dev/null
done
