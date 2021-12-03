#!/usr/bin/env bash

{
	find /Applications -name "*.app" -maxdepth 2 & \
	find /System/Applications -name "*.app" -maxdepth 2 & \
	find /System/Library/CoreServices -name "*.app" -maxdepth 2
} | fzf --layout=reverse --border | xargs -I {} open {}
