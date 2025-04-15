#!/usr/bin/env bash

clear

while true; do
	screen=$("$@")
	tput cup 0 0
	printf "%s" "$screen"
	sleep 2
done
