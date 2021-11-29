#!/usr/bin/env bash

function tmux_session() {
  echo -n $(tmux list-sessions | grep attached | awk '{print $1}' | tr -d ":" | xargs -n1 basename)
}

function main() {
  echo -n "🔸 $(tmux_session) 🔷 "
}

echo "🔸"

