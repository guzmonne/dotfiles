#!/usr/bin/env bash

playbook=$(find "$HOME/Projects/Personal/ansible" -maxdepth 1 | sed "s|$HOME/Projects/Personal/ansible/||g" | sed 's/ /\n/g' | grep yml | grep -v requirements.yml | fzf-tmux -p 40%,30%)

if [ -z "$playbook" ]; then exit 0; fi

ansible-playbook "$HOME/Projects/Personal/ansible/$playbook" --extra-vars="root=$HOME/Projects/Personal"
