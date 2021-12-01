#!/usr/bin/env bash

if [ -z "${TMUX}" ]; then
	echo "You are not inside a tmux session"
else
	tmux select-window -t ${1:-1}
fi
