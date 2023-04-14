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

# @cmd Create a proper Git Commit message from the diff of changes.
commit() {
  changes="$(mktemp)"
  {
    for file in $(git diff --staged --name-only); do
      {
        cat <<-EOF | b --silent chats create
Create a bullet point summary of the changes made to the file $file on the current git commit
from its "git diff" output. Please avoid printing back sensitive information like the values
of environment variables, or passwords.

Include the name of the file in the summary as the heading. For example:

"""
Changes to file $file:

- ...
"""

Git Diff:
$(
          while read -r line; do
            case "$line" in
              +*) printf "%s\n" "$line" ;;
              -*) printf "%s\n" "$line" ;;
            esac
          done <<<"$(git diff --staged -- "$file")"
        )
EOF
        echo
        echo
      } &
    done
    wait
  } >"$changes"

  if [[ -z $(cat "$changes") ]]; then
    echo "No changes detected"
    exit 0
  fi

  cat <<-EOF | b chats create
Create a brief summary using a single paragraph describing all the main changes done
since the last git commit from the following list of changes. Also, the first line must
be a "Semantic Commit Message" that describes the changes in a single line.

You MUST separate the semantic commit from the summary paragraph with a new line.

Examples:

"""
feat: add support for GPT-3

fix: fix bug in the google-credentials.sh script

chore: update the aws.sh script
"""

List of changes:

"""
$(cat "$changes")
"""

EOF

  echo
  echo
  echo ---
  echo
  cat "$changes"
}

# @cmd Make a request to GPT
# @option --prompt GPT Prompt.
# @option --file File to store the request response.
# @option --model=text-davinci-003 GPT Model.
# @option --maxTokens=2096 GPT max tokens.
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

  cat "$argc_file"
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
# @option --maxTokens=2096 GPT max tokens.
# @option --temperature=0.2 GPT temperature.
main() {
  local tmp
  local history_file
  local response
  local prompt
  local completion
  local text

  history_file="/tmp/gpt.sh.history"
  touch "$history_file"

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

  cat "$history_file" >"$tmp"

  "$EDITOR" + "$history_file"

  if [[ -z $(diff "$tmp" "$history_file") ]]; then
    printf "\rNo changes detected\n"
    exit 0
  else
    $self main \
      --model="$argc_model" \
      --maxTokens="$argc_maxTokens" \
      --temperature="$argc_temperature"
  fi

}

# @cmd Record an mp3 audio file, send it to OpenAI's whisper API, and print the response content to stdout.
# @option -p --path Record file path.
# @option --completionModel=text-davinci-003 GPT Model.
# @option --whisperModel=whisper-1
# @option --maxTokens=256 GPT max tokens.
# @option --temperature=0 GPT temperature.
whisper() {
  if [[ -z $argc_path ]]; then
    argc_path="$(mktemp).mp3"
  fi

  # Record an mp3 audio file
  rec -c 1 -r 16000 -b 16 -e signed-integer -t raw - |
    sox -t raw -r 16000 -b 16 -e signed-integer - -t mp3 "$argc_path"

  # Send the audio file to OpenAI's whisper API
  response=$(
    curl -X POST "https://api.openai.com/v1/audio/transcriptions" \
      -H "Content-Type: multipart/form-data" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      --form file=@"$argc_path" \
      --form "model=$argc_whisperModel"
  )

  # Print the response content to stdtut
  prompt="$(jq -r '.text' <<<"$response" | tr '[:upper:]' '[:lower:]')"
  tmp="$(mktemp)"
  $self request --model "$argc_completionModel" --maxTokens "$argc_maxTokens" --temperature "$argc_temperature" --prompt "$prompt" --file "$tmp" &

  _spinner $! "Running..."

  response="$(cat "$tmp")"
  completion=$(printf '%s' "$response" | jq -r '.choices[0].completion')
  text=$(printf '%s' "$response" | jq -r '.choices[0].text')

  if [[ $completion == "null" ]] || [[ $completion == "" ]]; then
    completion="$text"
  fi

  echo
  echo "$prompt"
  echo "$completion"
}

if [[ -z $1 ]]; then
  set -- "main" "$@"
fi

case "$1" in
  -h | --help) ;;
  -*)
    set -- "main" "$@"
    ;;
esac

eval "$(argc "$self" "$@")"
