#!/usr/bin/env bash

config=$(gcloud config configurations list |
	tail -n +2 |
	awk '{print $1}' |
	fzf-tmux -p 80%,40% --preview 'gcloud config configurations describe {}')

if [ -z "$config" ]; then exit 0; fi

gcloud auth revoke --all
gcloud config configurations activate "$config"
gcloud auth login
gcloud auth application-default login

clear

hr.sh '─'

gcloud config configurations describe "$config"

hr.sh '─'
