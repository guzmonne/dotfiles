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

# URL-encode a string
#
# Encodes a string using RFC 2396 URL-encoding (%-escaped).
# See: https://www.ietf.org/rfc/rfc2396.txt
#
# By default, reserved characters and unreserved "mark" characters are
# not escaped by this function. This allows the common usage of passing
# an entire URL in, and encoding just special characters in it, with
# the expectation that reserved and mark characters are used appropriately.
# The -r and -m options turn on escaping of the reserved and mark characters,
# respectively, which allows arbitrary strings to be fully escaped for
# embedding inside URLs, where reserved characters might be misinterpreted.
#
# Prints the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#  urlencode [-r] [-m] [-P] <string> [<string> ...]
#
#    -r causes reserved characters (;/?:@&=+$,) to be escaped
#
#    -m causes "mark" characters (_.!~*''()-) to be escaped
#
#    -P causes spaces to be encoded as '%20' instead of '+'
function urlencode() {
  emulate -L zsh
  local -a opts
  zparseopts -D -E -a opts r m P

  local in_str="$@"
  local url_str=""
  local spaces_as_plus
  if [[ -z $opts[(r)-P] ]]; then spaces_as_plus=1; fi
  local str="$in_str"

  # URLs must use UTF-8 encoding; convert str to UTF-8 if required
  local encoding=$langinfo[CODESET]
  local safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$encoding]} ]]; then
    str=$(echo -E "$str" | iconv -f $encoding -t UTF-8)
    if [[ $? != 0 ]]; then
      echo "Error converting string from $encoding to UTF-8" >&2
      return 1
    fi
  fi

  # Use LC_CTYPE=C to process text byte-by-byte
  # Note that this doesn't work in Termux, as it only has UTF-8 locale.
  # Characters will be processed as UTF-8, which is fine for URLs.
  local i byte ord LC_ALL=C
  export LC_ALL
  local reserved=';/?:@&=+$,'
  local mark='_.!~*''()-'
  local dont_escape="[A-Za-z0-9"
  if [[ -z $opts[(r)-r] ]]; then
    dont_escape+=$reserved
  fi
  # $mark must be last because of the "-"
  if [[ -z $opts[(r)-m] ]]; then
    dont_escape+=$mark
  fi
  dont_escape+="]"

  # Implemented to use a single printf call and avoid subshells in the loop,
  # for performance (primarily on Windows).
  local url_str=""
  for (( i = 1; i <= ${#str}; ++i )); do
    byte="$str[i]"
    if [[ "$byte" =~ "$dont_escape" ]]; then
      url_str+="$byte"
    else
      if [[ "$byte" == " " && -n $spaces_as_plus ]]; then
        url_str+="+"
      elif [[ "$PREFIX" = *com.termux* ]]; then
        # Termux does not have non-UTF8 locales, so just send the UTF-8 character directly
        url_str+="$byte"
      else
        ord=$(( [##16] #byte ))
        url_str+="%$ord"
      fi
    fi
  done
  echo -E "$url_str"
}

# URL-decode a string
#
# Decodes a RFC 2396 URL-encoded (%-escaped) string.
# This decodes the '+' and '%' escapes in the input string, and leaves
# other characters unchanged. Does not enforce that the input is a
# valid URL-encoded string. This is a convenience to allow callers to
# pass in a full URL or similar strings and decode them for human
# presentation.
#
# Outputs the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#   urldecode <urlstring>  - prints decoded string followed by a newline
function urldecode {
  emulate -L zsh
  local encoded_url=$1

  # Work bytewise, since URLs escape UTF-8 octets
  local caller_encoding=$langinfo[CODESET]
  local LC_ALL=C
  export LC_ALL

  # Change + back to ' '
  local tmp=${encoded_url:gs/+/ /}
  # Protect other escapes to pass through the printf unchanged
  tmp=${tmp:gs/\\/\\\\/}
  # Handle %-escapes by turning them into `\xXX` printf escapes
  tmp=${tmp:gs/%/\\x/}
  local decoded="$(printf -- "$tmp")"

  # Now we have a UTF-8 encoded string in the variable. We need to re-encode
  # it if caller is in a non-UTF-8 locale.
  local -a safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$caller_encoding]} ]]; then
    decoded=$(echo -E "$decoded" | iconv -f UTF-8 -t $caller_encoding)
    if [[ $? != 0 ]]; then
      echo "Error converting string from UTF-8 to $caller_encoding" >&2
      return 1
    fi
  fi

  echo -E "$decoded"
}
