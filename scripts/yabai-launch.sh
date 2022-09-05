#!/usr/bin/env bash
# Launches a new applications on its corresponding space.
# @arg label - Label for the application yabai space.
# @arg app - Name of the application to launch. Must be a valid key of the apps dictionary.
# @arg display - Number of the display where the app should be launched.

set -xe

label="$1"
app="$2"
display=1

if [[ -n "$3" ]]; then
	display="$3"
fi

yabai -m rule --remove "$label" || True

if [[ -n "$(yabai -m query --windows | jq '.[] | select(.app == "'"$app"'")')" ]]; then
	space_index="$(yabai -m query --windows | jq '.[] | select(.app == "'"$app"'") | .space')"
	window_id="$(yabai -m query --windows | jq '.[] | select(.app == "'"$app"'") | .id')"
	yabai -m space --focus "$space_index" || True
	yabai -m space "$space_index" --label "$label"
	yabai -m space "$space_index" --display "$display" || True
	yabai -m rule --add label="$label" app="$app" space="$label" display="$display"
	yabai -m window "$window_id" --focus || True
else
	yabai -m space --create
	space_index="$(yabai -m query --spaces --display | jq 'map(select(."is-visible" == false))[-1].index')"
	yabai -m space --focus "$space_index"
	yabai -m space "$space_index" --label "$label"
	yabai -m space "$space_index" --display "$display" || True
	yabai -m rule --add label="$label" app="$app" space="$label" display="$display"
	echo "Opening: $app"
	open "/Applications/$app.app"
	sleep 3
fi

set +x
