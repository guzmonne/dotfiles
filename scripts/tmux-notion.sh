#!/usr/bin/env bash

read -r -p "Note title: " title

echo "Enjoy writing your note in Notion"

if [ -z "${TMUX}" ]; then
	notion "$title"
else
	tmux new-window bash -c "notion \"$title\""
fi
