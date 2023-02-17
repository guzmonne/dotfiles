#!/usr/bin/env bash
# shellcheck disable=SC2154

# @describe Run string case convertions.
# @author Guzmán Monné
# @version 1.0.0

self="$0"

# @cmd Converts a string to snake case.
# @arg string The string to convert.
to-snake() {
  echo "$argc_string" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]'
}

# @cmd Converts a string to dash case.
# @arg string The string to convert.
to-dash() {
  $self to-snake "$argc_string" | sed 's|_|-|g'
}

# @cmd Converts a string to camel case.
# @arg string The string to convert.
to-camel() {
  $self to-dash "$argc_string" | perl -pe 's/-(.)/\u$1/g'
}

eval "$(argc "$0" "$@")"
