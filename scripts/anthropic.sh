#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC2181

# @describe Talk with Anthropic Claude from the console.
# @author Guzmán Monné
# @version 1.0.0

# Activate DEBUG mode.
if [[ -n ${DEBUG} ]]; then
  set -ex
else
  set -e
fi

# Check for the existance of the OPENAI KEY.
if [[ -z ${ANTHROPIC_API_KEY}   ]]; then
  echo "ANTHROPIC_API_KEY must be set"
  exit 1
fi

self="$0"

spinner() {
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
# @option --model=claude-v1.2 Anthropic Claude Model
# @option --maxTokensToSample=1024 A maximum number of tokens to generate before stopping.
# @option --stopSequences=\n\nHuman: String upon which to stop the generation.
# @option --temperature=0 Amount of randomness injected into the response.
# @option --topK=-1 Only sample from the top K options for each subsequent token.
# @option --topP=-1 Does nucleus sampling, in which we compute the cumulative distribution over all the options for each subsequent token in decreasing probability order and cut it off once it reaches a particular probability specified by `topP`.
# @flag --stream Stream to pipe the output to.
# @arg prompt* Model prompt.
complete() {
  local request_body
  local escaped_prompt

  escaped_prompt="$(printf '%s' "${argc_prompt[*]}" | jq -Rsa .)"
  request_body="$({
    tee <<-EOF
{
  "prompt": $escaped_prompt,
  "model": "$argc_model",
  "max_tokens_to_sample": "$argc_maxTokensToSample",
  "temperature": $argc_temperature,
  "stop_sequences": ["$argc_stopSequences", "\n\n\n"],
  "top_p": $argc_topP,
  "top_k": $argc_topK
}
EOF
  })"
  request_body="$(jq -c <<<"$request_body")"

  options="-s"
  if [[ -n $argc_stream ]]; then
    options="-sN"
  fi

  tmp="$(mktemp)"

  curl $options -X POST \
    -H "content-type: application/json" \
    -H "x-api-key: ${ANTHROPIC_API_KEY}" \
    --data "$request_body" \
    "https://api.anthropic.com/v1/complete" \
    -o "$tmp"

  echo -e "${argc_prompt[*]}$(jq -r '.completion' "$tmp")" | glow
}

eval "$(argc "$self" "$@")"
