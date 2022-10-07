#!/usr/bin/env bash

ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

"$ROOT/yabai-clean.sh"
"$ROOT/yabai-clean.sh"
"$ROOT/yabai-launch.sh" "kitty" "kitty" 1
"$ROOT/yabai-launch.sh" "brave" "Brave Browser" 1
"$ROOT/yabai-launch.sh" "firefox" "Firefox Developer Edition" 1
"$ROOT/yabai-launch.sh" "outlook" "Microsoft Outlook" 2
"$ROOT/yabai-launch.sh" "slack" "Slack" 2
"$ROOT/yabai-launch.sh" "fantastical" "Fantastical" 2
"$ROOT/yabai-launch.sh" "spotify" "Spotify" 2
"$ROOT/yabai-launch.sh" "linear" "Linear" 2
"$ROOT/yabai-launch.sh" "zoom" "zoom.us" 2
"$ROOT/yabai-launch.sh" "safari" "Safari" 1

# Correct labels
yabai -m space 1 --label "kitty"
yabai -m space 2 --label "brave"
yabai -m space 3 --label "firefox"
yabai -m space 4 --label "outlook"
yabai -m space 5 --label "slack"
yabai -m space 6 --label "fantastical"
yabai -m space 7 --label "spotify"
yabai -m space 8 --label "linear"
yabai -m space 9 --label "zoom"
yabai -m space 10 --label "safari"

# Focus on kitty once eveything is done
yabai -m space --focus "kitty"
