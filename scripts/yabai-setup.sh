#!/usr/bin/env bash

ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

"$ROOT/yabai-clean.sh"
"$ROOT/yabai-clean.sh"
"$ROOT/yabai-launch.sh" "kitty" "kitty" 1
"$ROOT/yabai-launch.sh" "brave" "Brave Browser" 2
"$ROOT/yabai-launch.sh" "firefox" "Firefox Developer Edition" 2
"$ROOT/yabai-launch.sh" "safari" "Safari" 2
"$ROOT/yabai-launch.sh" "outlook" "Microsoft Outlook" 3
"$ROOT/yabai-launch.sh" "slack" "Slack" 3
"$ROOT/yabai-launch.sh" "fantastical" "Fantastical" 3
"$ROOT/yabai-launch.sh" "spotify" "Spotify" 3
"$ROOT/yabai-launch.sh" "zoom" "zoom.us" 3

# Correct labels
"$ROOT/yabai-connect.sh"
