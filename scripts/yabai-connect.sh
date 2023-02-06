#!/usr/bin/env bash

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
yabai -m space --focus "kitty" || True
