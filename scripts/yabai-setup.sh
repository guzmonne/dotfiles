#!/usr/bin/env bash

ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

"$ROOT/yabai-clean.sh"
"$ROOT/yabai-clean.sh"
"$ROOT/yabai-launch.sh" "kitty" "kitty" 1
"$ROOT/yabai-launch.sh" "brave" "Brave Browser" 1
"$ROOT/yabai-launch.sh" "firefox" "Firefox Developer Edition" 1
"$ROOT/yabai-launch.sh" "safari" "Safari" 1
"$ROOT/yabai-launch.sh" "outlook" "Microsoft Outlook" 2
"$ROOT/yabai-launch.sh" "slack" "Slack" 2
"$ROOT/yabai-launch.sh" "fantastical" "Fantastical" 2
"$ROOT/yabai-launch.sh" "spotify" "Spotify" 2
"$ROOT/yabai-launch.sh" "linear" "Linear" 2
"$ROOT/yabai-launch.sh" "zoom" "zoom.us" 2

# Correct labels
"$ROOT/yabai-connect.sh"
