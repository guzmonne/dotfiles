#!/usr/bin/env bash

yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Firefox Developer Edition"))[].id')" --display 2 --space 4
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Safari"))[].id')" --display 2 --space 5
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Alacritty"))[].id')" --display 1 --space 1
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Brave Browser"))[].id')" --display 2 --space 3
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Slack"))[].id')" --display 3 --space 7
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Slack"))[].id')" --display 3 --space 8
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Spotify"))[].id')" --display 3 --space 9
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Microsoft Outlook"))[].id')" --display 3 --space 6
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="zoom.us"))[].id')" --display 2 --space 5
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="Arc"))[].id')" --display 2 --space 2
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="OpenEmu"))[].id')" --display 3 --space 10
yabai -m window "$(yabai -m query --windows | jq -r 'map(select(.app=="AWS VPN Client"))[].id')" --display 2 --space 5

yabai -m space 1 --label "alacritty"
yabai -m space 2 --label "arc"
yabai -m space 3 --label "brave"
yabai -m space 4 --label "firefox"
yabai -m space 5 --label "safari"
yabai -m space 6 --label "outlook"
yabai -m space 7 --label "slack"
yabai -m space 8 --label "fantastical"
yabai -m space 9 --label "spotify"

# Focus on kitty once eveything is done
yabai -m space --focus "alacritty" || True
