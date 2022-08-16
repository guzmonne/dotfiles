#!/usr/bin/env bash

selected=$(https -pb cht.sh/:list | fzf)

read -r -p "? " query
tmux new-window bash -c "curl cht.sh/$selected~$query | less"
