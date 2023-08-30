# Adds a plugin.
function zsh_add_plugin() {
  ORG=$(echo $1 | cut -d "/" -f 1)
  PLUGIN=$(echo $1 | cut -d "/" -f 2)
  if [ ! -d "$HOME/.config/repos/$ORG/$PLUGIN" ]; then
    git clone --depth=1 "git@github.com:$1.git" "$HOME/.config/repos/$ORG/$PLUGIN"
  fi

  if [ -f "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.plugin.zsh" ]; then
    source "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.plugin.zsh"
  elif [ -f "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh" ]; then
    source "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh"
  elif [ -f "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh-theme" ]; then
    source "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh-theme"
   fi
}

# Configures the correct version of node using nvm
function load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

# Handy function to interact with `c` My custom LLM chat cli.
function chat() {
  if [ -z "$1" ]; then
    session="$(find ~/.c/sessions -name "*.yaml" -maxdepth 1 -exec basename {} \; | awk -F'.' '{print $1}' | fzf)"
  else
    session="$1"
    shift
  fi

  if [[ "$session" == "" ]]; then
    echo "No session selected"
    return 1
  fi

  if [[ "$1" == "edit" ]]; then
    nvim ~/.c/sessions/"$session".yaml
    return 0
  fi

  if [[ "$1" == "" ]]; then
    tmp="$(mktemp)"

    if [ ! -f "~/.c/sessions/${session}.yaml" ]; then
      one="$(yq '.history[-2]' ~/.c/sessions/$session.yaml)"
      two="$(yq '.history[-1]' ~/.c/sessions/$session.yaml)"

      if [[ -n "$one" ]]; then
        echo "# $(yq '.role' <<<"$one")" >>"$tmp"
        echo >> "$tmp"
        echo "$(yq '.content' <<<"$one")" >>"$tmp"
      fi

			echo >> "$tmp"

      if [[ -n "$two" ]]; then
        echo "# $(yq '.role' <<<"$two")" >>"$tmp"
        echo >> "$tmp"
        echo "$(yq '.content' <<<"$two")" >>"$tmp"
      fi

      echo >> "$tmp"
      echo '<EOF/>' >> "$tmp"
      echo >> "$tmp"
      echo >> "$tmp"
    else
      echo "Can't find file ~/.c/sessions/$session.yaml"
    fi

    nvim +'normal Gzt' +'set filetype=markdown' +'startinsert' "$tmp"

    if [[ $! -ne 0 ]]; then
      return $!
    fi

    prompt="$(grep -an '<EOF/>' "$tmp" | awk -F':' '{ print $1 }' | xargs -n1 -I{} expr 2 + {} | xargs -n1 -I{} tail -n +{} "$tmp")"
  else
    prompt="$@"
  fi

  vendor="$(yq '.vendor' ~/.c/sessions/"$session".yaml)"

  case "$vendor" in
    Anthropic)
      subcommand="anthropic"
      ;;
    OpenAI)
      subcommand="openai"
      ;;
    Google)
      refresh-c-gcp-key
      subcommand="vertex"
      ;;
    *)
      echo "Unknown vendor $vendor"
      return 1
      ;;
  esac

  c $subcommand --session "$session" --stream "$prompt"
}

# OpenCommit alias Aliases
function oc() {
  npx -y opencommit "$@"
}

# A simple function to generate and store information about how to use the command line.
function um() {
  if [[ -z "$1" ]]; then
    echo "Please provide a command to document"
    return 1
  fi

  nvim ~/Projects/Personal/secrets/wiki/um/"$1".md
}

# Get the Markdown file for the requested Rust rule
function re() {
  if [[ -z "$1" ]]; then
    echo "Please provide a rule to document"
    return 1
  fi

  tmp="$(mktemp).md"

  curl -s https://raw.githubusercontent.com/rust-lang/rust/27a43f083480a3a2a02a544a8ab6030aaab73a53/compiler/rustc_error_codes/src/error_codes/E$1.md > "$tmp"

  nvim "$tmp"
}

# Get the Markdown file for the requested HADOLINT rule
function dl() {
  if [[ -z "$1" ]]; then
    echo "Please provide a rule to document"
    return 1
  fi

  tmp="$(mktemp).md"

  curl -s https://raw.githubusercontent.com/codacy/codacy-hadolint/master/codacy-hadolint/docs/description/DL$1.md > "$tmp"

  nvim "$tmp"
}

# Refresh the C_GCP_KEY env variable
function refresh-c-gcp-key() {
  if command -v gcloud &> /dev/null; then
    if [[ -f "$HOME/Projects/Personal/secrets/google/cloudbridgeuy-vertex-key.json" ]]; then
      gcloud auth activate-service-account --key-file=$HOME/Projects/Personal/secrets/google/cloudbridgeuy-vertex-key.json
      export C_GCP_KEY="$(gcloud auth print-access-token)"
    else
      echo "No key file found"
      return 1
    fi
  else
    echo "gcloud not installed"
    return 1
  fi
}
