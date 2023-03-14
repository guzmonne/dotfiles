#!/usr/bin/env bash
# shellcheck disable=SC2155
# @describe Convert websites into Markdown and render them with Glow.
# @author Guzmán Monné
# @version 1.0.0

# @cmd Get a webpage to render
# @arg url Webpage URL.
get() {
  readonly tmp="$(mktemp)"

  curl -sL "$1" | percollate md -o "$tmp"

  glow --pager "$tmp"

  rm -rf "$tmp"
}

eval "$(argc "$0" "$@")"
