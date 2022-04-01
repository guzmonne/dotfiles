#/usr/bin/env bash

folder_name=$(folders.sh)
safe_folder_name=$(printf $folder_name | tr '.' '_')

if ! tmux has-session -t "=$safe_folder_name" 2> /dev/null; then
  tmux new-session -s "$safe_folder_name" -c "$folder_name" -d
fi

if ! tmux attach -t "=$safe_folder_name" 2> /dev/null; then
  tmux switch-client -t "=$safe_folder_name"
fi
