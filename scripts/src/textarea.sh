#!/usr/bin/env bash
# @name textarea
# @version 0.1.0
# @description Use nvim as a textare
# @author Guzmán Monné

root() {
  tmpfile="$(mktemp).md"
  trap 'rm -f "$tmpfile"' exit
  touch "$tmpfile"
  nvim "$tmpfile" >/dev/tty
  cat "$tmpfile"
}
