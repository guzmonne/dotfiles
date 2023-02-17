#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC2181

# @describe Run GPT-3 from the console.
# @author Guzmán Monné
# @version 1.0.0

# Activate DEBUG mode.
if [[ -n ${DEBUG} ]]; then
  set -ex
else
  set -e
fi

# Check for the existance of the OPENAI KEY.
if [[ -z ${OPENAI_API_KEY}   ]]; then
  echo "OPENAI_API_KEY must be set"
  exit 1
fi

self="$0"

# @cmd Make a request to GPT
# @option --prompt GPT Prompt.
# @option --file File to store the request response.
# @option --model=completion-davinci-003 GPT Model.
# @option --maxTokens=256 GPT max tokens.
# @option --temperature=0 GPT temperature.
request() {
  local request_body
  local escaped_prompt

  GPT_MODEL=${GPT_MODEL:-"$argc_model"}
  GPT_MAX_TOKENS=${GPT_MAX_TOKENS:-"$argc_maxTokens"}
  GPT_TEMPERATURE=${GPT_TEMPERATURE:-"$argc_temperature"}

  escaped_prompt="$(printf '%s' "$argc_prompt" | jq -Rsa .)"
  request_body='{"prompt": '"$escaped_prompt"', "model": "'"${GPT_MODEL}"'", "max_tokens": '"${GPT_MAX_TOKENS}"', "temperature": '"${GPT_TEMPERATURE}"' }'

  curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${OPENAI_API_KEY}" \
    --data "$request_body" \
    "https://api.openai.com/v1/completions" \
    -o "$argc_file"
}

_spinner() {
  local pid=$1
  local spinner=("⣼" "⣹" "⢻" "⠿" "⡟" "⣏" "⣧" "⣶")
  while true; do
    for i in "${spinner[@]}"; do
      if ! kill -0 "$pid" 2>/dev/null; then
        break 2
      fi
      printf "\r%s $2" "$i"
      sleep 0.05
    done
  done
  wait "$pid"
}

# @cmd Execute the command
# @flag --clean Clean the GPT history.
# @option --model=text-davinci-003 GPT Model.
# @option --maxTokens=256 GPT max tokens.
# @option --temperature=0 GPT temperature.
main() {
  local tmp
  local history_file
  local response
  local prompt
  local completion
  local text

  history_file="/tmp/gpt.sh.history"

  if [[ -n $argc_clean ]]; then
    /bin/rm -r "$history_file" || true
    touch "$history_file"
  fi

  tmp="$(mktemp)"

  cp "$history_file" "$tmp"
  "$EDITOR" + "$history_file"

  if [[ -z $(diff "$tmp" "$history_file") ]]; then
    echo "No changes detected"
    exit 0
  fi

  prompt="$(cat "$history_file")"

  $self request --model "$argc_model" --maxTokens "$argc_maxTokens" --temperature "$argc_temperature" --prompt "$prompt" --file "$tmp" &

  _spinner $! "Running..."

  response="$(cat "$tmp")"
  completion=$(printf '%s' "$response" | jq -r '.choices[0].completion')
  text=$(printf '%s' "$response" | jq -r '.choices[0].text')

  if [[ $completion == "null" ]] || [[ $completion == "" ]]; then
    completion="$text"
  fi

  echo "$completion" >>"$history_file"

  "$EDITOR" + "$history_file"
}

if [[ $1 != "request" ]] && [[ $1 != "--help" ]] && [[ $1 != "main" ]]; then
  set -- "main" "$@"
fi

eval "$(argc "$self" "$@")"
