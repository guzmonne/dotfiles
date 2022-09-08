#!/usr/bin/env bash
# Launches a new applications on its corresponding space.
# If the application is already running, then we set-up it's current space.
# Else, we look for a space that has no windows to set-up for that app. If we can't find one, we
# create one and restart the procedure.
# @arg label - Label for the application yabai space.
# @arg app - Name of the application to launch. Must be a valid key of the apps dictionary.
# @arg display - Number of the display where the app should be launched.

set -xe

# Removes a rule by application label.
# @arg label - Application label.
rule_remove() {
	yabai -m rule --remove "$1" || True
}

# Adds a new rule to handle the app.
# @arg label - Rule selection value.
# @arg app - Application full name.
# @arg display - Display where the app should be sent to.
rule_add() {
	rule_remove "$1"
	yabai -m rule --add label="$1" app="$2" space="$1" display="$3" || True
}

# Finds an app window if it exists.
# @arg app - Name of the app to look for.
find_app() {
	yabai -m query --windows | jq '.[] | select(.app == "'"$1"'")'
}

# Applies a label to a space.
# @arg space_sel - Yabai space selector.
# @arg label - Label to apply.
space_label() {
	yabai -m space "$1" --label "$2"
}

# Assigns a space to a specific display.
# @arg space_sel - Yabai space selector.
# @arg display - Display where the space will be assigned to.
space_display() {
	yabai -m space "$1" --display "$2" || True
}

# Focus on a given display.
# @arg space_sel - Yabai space selector.
space_focus() {
	yabai -m space --focus "$1" || True
}

# Find a space with no windows.
# @arg display - Display where to look for empty spaces.
space_empty() {
	# Return empty if there's only one space available on the display.
	if [[ "$(yabai -m query --spaces --display "$1" | jq 'length')" == 1 ]]; then
		return
	fi
	# Return empty if there are no spaces with no windows.
	if [[ "$(yabai -m query --spaces --display "$1" | jq '[.[] | select(.windows | length == 0)] | length')" == 0 ]]; then
		return
	fi
	# Return the last empty space.
	yabai -m query --spaces --display "$1" | jq '[.[] | select(.windows | length == 0)][-1]'
}

# Creates a new space on a specific display.
# @arg display - Display where to look for empty spaces.
space_create() {
	display_focus "$1"
	yabai -m space --create
	space_empty "$1"
}

# Focus on a given window
# @arg window_sel - Yabai window selector.
window_focus() {
	yabai -m window "$1" --focus || True
}

# Opens an application
# @arg app - Application full name.
# @arg space_sel - Space selector to check if the window for the app has been created
app_open() {
	/usr/bin/env osascript <<< \
		"display notification \"Opening $1\" with title \"Yabai Launch\""
	open "/Applications/$1.app"
	# Wait until the app opens.
	while True; do
		sleep 1
		if [[ "$(yabai -m query --spaces --space "$2" | jq '.windows | length')" == 1 ]]; then
			break
		fi
	done
	/usr/bin/env osascript <<< \
		"display notification \"Done!\" with title \"Yabai Launch\""
}

# Focus on a specific display
# @arg display - Given display to focus.
display_focus() {
	yabai -m display --focus "$1"
}

# Main execution funcion
# @arg label - Application label.
# @arg app - Application full name.
# @arg display - Optional display location [@default 1]
main() {
	label="$1"
	app="$2"
	display=1

	if [[ -n "$3" ]]; then
		display="$3"
	fi

	display_focus "$display"

	if [[ -n "$(find_app "$app")" ]]; then
		space_sel="$(find_app "$app" | jq '.space')"
	elif [[ -n "$(space_empty "$display")" ]]; then
		space_sel="$(space_empty "$display" | jq '.index')"
	else
		space_sel="$(space_create "$display" | jq '.index')"
	fi

	space_focus "$space_sel"
	space_label "$space_sel" "$label"
	space_display "$space_sel" "$display"
	rule_add "$label" "$app" "$display"

	if [[ -n "$(find_app "$app")" ]]; then
		return
	fi

	app_open "$app" "$space_sel"
}

# Execute main function
main "$@"

set +x

# lsblk
# ps -ef | grep diamond
# cd /usr/share/diamond/collectors/diskusage/
# systemctl restart diamond
# cd /var/log/diamond/
#
