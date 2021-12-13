#/usr/bin/env bash

config=$(gcloud config configurations list |\
          tail -n +2 |\
          awk '{print $1}' |\
          fzf-tmux -p 80%,40% --preview 'gcloud config configurations describe {}')

if [ -z "$config" ]; then exit 0; fi

clear

hr.sh '─'

gcloud config configurations activate $config

gcloud config configurations describe $config

dotenv -f ~/.config/ohmyposh/.env set OHMYPOSH_GOOGLE_CREDENTIALS=$config

hr.sh '─'
