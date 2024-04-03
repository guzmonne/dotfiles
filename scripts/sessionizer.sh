#!/usr/bin/env bash
# @describe Handle tumx sessions.
# @author Guzmán Monné
# @version 0.1.0

ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

# @cmd Handle the Sessionizer config
config() {
  "$ROOT/config" "$@"
}

# @cmd Handle Sessionizer folders
folders() {
  "$ROOT/folders" "$@"
}

# @cmd Handle Sessionizer tmux sessions
sessions() {
  "$ROOT/sessions" "$@"
}

# @cmd Handle Sessionizer sources
sources() {
  "$ROOT/sources" "$@"
}

case "$1" in
  config)  shift; config  "$@"; exit;;
  folders) shift; folders "$@"; exit;;
  sessions) shift; sessions "$@"; exit;;
  sources) shift; sources "$@"; exit;;
esac

eval "$(argc "$0" "$@")"


