#!/usr/bin/env bash

function tmux_session() {
  echo -n $(tmux list-sessions | grep attached | awk '{print $1}' | tr -d ":")
}

function main() {
  echo -n "🔸 $(tmux_session) 🔷 "
}

main
