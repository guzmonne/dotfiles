#!/usr/bin/env bash

ROOT="$(dirname "$(readlink -f "$(which "$0")")")"

kitty() {
  yabai -m space --focus "kitty" || True
}

"$ROOT/yabai-clean.sh" && kitty
"$ROOT/yabai-launch.sh" "kitty" "kitty" 1
"$ROOT/yabai-launch.sh" "brave" "Brave Browser" 2 && kitty
"$ROOT/yabai-launch.sh" "firefox" "Firefox Developer Edition" 2 && kitty
"$ROOT/yabai-launch.sh" "safari" "Safari" 2 && kitty
"$ROOT/yabai-launch.sh" "outlook" "Microsoft Outlook" 3 && kitty
"$ROOT/yabai-launch.sh" "slack" "Slack" 3 && kitty
"$ROOT/yabai-launch.sh" "fantastical" "Fantastical" 3 && kitty
"$ROOT/yabai-launch.sh" "spotify" "Spotify" 3 && kitty
"$ROOT/yabai-launch.sh" "zoom" "zoom.us" 2 && kitty

# Correct labels
"$ROOT/yabai-connect.sh"
