#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2154
# @name gpt.sh
# @description Useful commands to interact with LLMs from the CLI.
# @author Guzmán Monné
# @dep curl,c Install with brew
# @default write

# @cmd Writes a message to anthropic or openai using `c`.
# @option -m --model[=gpt4|claude2] The model to use.
# @arg prompt The prompt to use.
write() {
  # If the model is gpt4 we'll want to use the openai command, and if its claude2 we want to use
  # anthropic instead.
  if [[ "$rargs_model" == "gpt4" ]]; then
    command="openai"
  elif [[ "$rargs_model" == "claude2" ]]; then
    command="anthropic"
  else
    echo "Invalid model: $rargs_model"
    exit 1
  fi

  # If the prompt is empty we'll open `nvim` to write the prompt, then save it to the `prompt`
  # variable.
  # If the prompt value is empty or it equals `-` we listend from stdin.
  if [[ "$rargs_prompt" == "-" ]]; then
    prompt=$(cat)
  elif [[ -z "$rargs_prompt" ]]; then
    tmp="$(mktemp)"
    nvim  \
      -c "setlocal filetype=markdown" \
      -c "startinsert" \
      -c "setlocal spell" \
      -c "setlocal spelllang=en_us" \
      "$tmp"
    prompt="$(cat "$tmp")"
  else
    prompt="$rargs_prompt"
  fi

  # Call `c` with the right command and pass in the prompt.
  printf '%s' "$prompt" | c "$command" -m "$rargs_model" --stream -
}
