#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC2090
# @name d
# @version 0.1.0
# @description A wrapper around `d`, my custom OpenAi cli tool.
# @author Guzmán Monné
# @env OPENAI_API_KEY! Your OpenAI API key.

gum="/opt/homebrew/bin/gum"
textarea="$HOME/.local/bin/textarea.sh"
last_used_session_path="$HOME/.d/last_used_session"
d="$HOME/.local/bin/d"

# @cmd Filter a list of values
# @private
filter() {
	cat - |
		$gum filter \
			--reverse \
			--prompt="❯ " \
			--indicator=" " \
			--selected-prefix=" ◉ " \
			--unselected-prefix=" ○ " \
			--limit=1 \
			--placeholder="Type to filter..." \
			--sort
}

# @cmd Input box
# @option -p --placeholder Input placeholder
# @option -h --header Input header
# @option -P --prompt Input prompt
# @private
input() {
	gum input \
		--placeholder="$rargs_placeholder" \
		--prompt="$rargs_prompt" \
		--header="$rargs_header" \
		--width=40 \
		--char-limit=400
}

# @cmd Gets the user prompt
# @private
get_prompt() {
	prompt="$($textarea)"

	if [[ -z "$prompt" ]]; then
		exit 1
	fi

	echo -n "$prompt"
}

# @cmd Choose a session using a gum filter
filter-session() {
	$d sessions list | jq -r '.[] | .' | filter | sort
}

# @cmd Choose a session using a gum filter
# @private
filter-options() {
	tee <<-EOF | filter
		1. Continue an existing session
		2. Start a new session
		3. Start anonymous session
		---
		0. Continue the last session
	EOF
}

# @cmd Starts a new anonymous session
start-anonymous-session() {
	$d chat "$(get_prompt)"
}

# @cmd Starts a new session
# @arg session Session name
start-new-session() {
	if [[ -z "$rargs_session" ]]; then
		rargs_session="$(input \
			-P "New Session: " \
			-h "Please enter a new name for the 'd' session" \
			-p "E.g. bashy")"
	fi

	if [[ -z "$rargs_session" ]]; then
		alert "The session name is required"
		return 1
	fi

	$d chat --session="$rargs_session" "$(get_prompt)"

	echo -n "$rargs_session" >"$last_used_session_path"
}

# @cmd Starts a new session
# @arg session Session name
continue-existing-session() {
	if [[ -z "$rargs_session" ]]; then
		rargs_session="$(filter-session)"
	fi

	if [[ -z "$rargs_session" ]]; then
		alert "The session name is required"
		return 1
	fi

	$d chat --session="$rargs_session" "$(get_prompt)"

	echo -n "$rargs_session" >"$last_used_session_path"
}

# @cmd Starts a new session
# @arg session Session name
continue-last-session() {
	if [[ -z "$rargs_session" ]]; then
		rargs_session="$(cat "$last_used_session_path")"
	fi

	if [[ -z "$rargs_session" ]]; then
		alert "The session name is required"
		return 1
	fi

	$d chat --session="$rargs_session" "$(get_prompt)"
}

# @option -o --option Option to chose
root() {
	if [[ -z "$rargs_option" ]]; then
		rargs_option="$(filter-options)"
	fi

	if [[ -z "$rargs_option" ]]; then
		alert "No option selected"
		return 1
	fi

	option="$(echo -n "$rargs_option" | awk -F'.' '{print $1}')"

	case "$option" in
	"1")
		continue-existing-session
		;;
	"2")
		start-new-session
		;;
	"3")
		start-anonymous-session
		;;
	"0")
		continue-last-session
		;;
	*)
		alert "No option selected"
		return 1
		;;
	esac
}
