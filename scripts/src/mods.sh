#!/usr/bin/env bash
# shellcheck disable=SC2154
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
	if [[ -z "$rargs_session" ]]; then
		rargs_session="$(
			$mods --list --raw |
				cut -c 9- |
				$gum filter \
					--reverse \
					--sort \
					--header="Select the mods session to use" \
					--placeholder="..." \
					--prompt="❯ " \
					--indicator=" "
		)"
	fi

	if [[ -z "$rargs_session" ]]; then
		continue="--continue $rargs_session"
	else
		continue=""
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

	$mods "$continue" "$rargs_session" "$other_args" "$prompt"
}
