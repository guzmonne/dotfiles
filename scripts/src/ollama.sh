#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC2016
# @name ollama
# @version 0.1.0
# @description A simple wrapper build around ollama
# @author Guzmán Monné
# @default run
# @rule no-first-option-help
# @flag -v --verbose Enable verbose output.

# @cmd Runs ollama against the given model
# @option -m --model! The model to run
# @flag --echo Echo the prompt
# @arg prompt! The prompt to use
generate() {
  if [[ "$rargs_prompt" == "-" ]]; then
    rargs_prompt="$(cat -)"
  fi

  if [[ "$rargs_echo" == "true" ]]; then
    printf "%s\n" "$rargs_prompt"
  fi

  curl -N -sX POST "http://localhost:11434/api/generate" -d "$(jo \
    model="$rargs_model" \
    prompt="$rargs_prompt" \
  )" | while read -r line; do
    if [[ -z "$line" ]]; then
      continue
    fi

    # Get the response key
    response="$(jq '.response' <<<"$line")"

    # Replace any backtick (`) with an escaped backtick (\`)
    response="${response//\`/\\\`}"
    # Remove \r characters.
    response="${response//$'\r'/}"

    eval printf "%s" "$(printf '%s' "$response" | grep -v '^null$' | perl -pe 's/\\n/\n/g')" 2>/dev/null
  done
}
