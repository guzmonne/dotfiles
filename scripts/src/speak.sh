#!/usr/bin/env bash
# shellcheck disable=SC2154
# @name ssh.sh
# @version 0.1.0
# @description Utility function to make the terminal speak using OpenAi.
# @author Guzman Monne
# @license MIT
# @default nvim

# @option -m --model=tts-1 The model to use.
# @option -v --voice=nova The voice to use.
# @option -f --format=mp3 The format to use.
# @option -i --input="-" The input text to speak.
# @arg text The text to speak.
root() {
	# If the text is empty or a dash, read from stdin.
	if [[ -z "$rargs_text" || "$rargs_text" == "-" ]]; then
		text="$(cat)"
	else
		text="$rargs_text"
	fi

	# Print the text to stderr.
	echo "$text" >&2

	curl -s https://api.openai.com/v1/audio/speech -H "Authorization: Bearer $OPENAI_API_KEY" -H "Content-Type: application/json" -d "$(
		jo \
			model="$rargs_model" \
			input="$text" \
			voice="$rargs_voice" \
			format="$rargs_format"
	)" | sox -t "$rargs_format" - -d 2>/dev/null
}
