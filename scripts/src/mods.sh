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

# @option -s --session The session to use.
root() {
	declare -a names
	declare -a continue

	# Assuming each session is on a new line and consists of an id followed by a name
	sessions="$($mods --list --raw 2>&1)"

	# Read the second column (Names) into the names array
	mapfile -t names < <(echo -n "$sessions" | awk -F'\t' '{print $2}')

	if [[ "$sessions" != *"No conversations found."* ]] && [[ -z "$rargs_session" ]]; then
		rargs_session="$(
			$gum filter \
				--value="" \
				--reverse \
				--sort \
				--header="Select the mods session to use" \
				--placeholder="..." \
				--prompt="❯ " \
				--indicator=" " <<<"$(printf "%s\n" "${names[@]}")" || true
		)"

		continue=('--continue' "$rargs_session")
	else
		continue=('--continue' "$rargs_session")
	fi

	prompt="$($textarea)"

	if [[ -z "$prompt" ]]; then
		gum style "Empty prompt" \
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
		return 1
	fi

	# shellcheck disable=SC2068
	$mods ${continue[@]} "$rargs_session" "$other_args" "$prompt"
}
