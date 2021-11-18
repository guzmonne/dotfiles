#!/usr/bin/env bash

read -p "Note title:" title

echo "Enjoy writing your note in Notion"

tmux new-window bash -c "notion $title"

