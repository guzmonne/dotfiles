#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC2090
# @name mods
# @version 0.1.0
# @description A script built around `rargs` to extend its functionality.
# @author Guzmán Monné
# @env OPENAI_API_KEY! Your OpenAI API key.
# @any <MODS_ARGUMENTS> Optional arguments to pass to "mods".

mods="/opt/homebrew/bin/mods"
gum="/opt/homebrew/bin/gum"
textarea="$HOME/.local/bin/textarea.sh"

export GLAMOUR_STYLE=/Users/guzmanmonne/.glamour.tokyonight

# @cmd Print an alert message
# @arg message Message to print inside the alert
# @private
alert() {
	gum style "$rargs_alert" \
		--foreground="blue" \
		--background="black" \
		--border="rounded" \
		--border-foreground="green" \
		--align="center" \
		--height=3 \
		--width=50 \
		--margin="1" \
		--padding="1" \
		--bold \
		--underline >&2
}

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

# @cmd Start a new mods session
# @option -t --title Session title
new() {
	if [[ -z "$rargs_title" ]]; then
		rargs_title="$(input \
			-P "New Title: " \
			-h "Please enter a new title for the 'mods' session" \
			-p "E.g. Bashy")"
	fi

	if [[ -z "$rargs_title" ]]; then
		alert "The session title name is required"
		return 1
	fi

	prompt="$(get_prompt)"

	$mods --title "$rargs_title" "$prompt"
}

# @cmd Selects an existing session
# @private
session() {
	# Assuming each session is on a new line and consists of an id followed by a name
	sessions="$($mods --list --raw 2>&1)"

	session="$(echo "$sessions" | filter)"

	echo "$session"
}

# @cmd Continue an existing session
cont() {
	line="$(session)"
	id="$(echo -n "$line" | awk -F'\t' '{print $1}' | tr -d ' ')"
	title="$(echo -n "$line" | awk -F'\t' '{print $2}')"

	prompt="$(get_prompt)"

	$mods --continue "$id" --title "$title" "$prompt"
}

show() {
	line="$(session)"
	id="$(echo -n "$line" | awk -F'\t' '{print $1}' | tr -d ' ')"

	$mods -s "$id"
}

# @option -o --option Option to chose
root() {
	if [[ -z "$rargs_option" ]]; then
		rargs_option="$(echo -e "1. Start a new session.\n2. Continue an existing session.\n3. Show existing session." | filter)"
	fi

	if [[ -z "$rargs_option" ]]; then
		alert "No option selected"
		return 1
	fi

	option="$(echo -n "$rargs_option" | awk -F'.' '{print $1}')"

	case "$option" in
	"1")
		new
		;;
	"2")
		cont
		;;
	"3")
		show
		;;
	*)
		alert "No option selected"
		return 1
		;;
	esac
}
