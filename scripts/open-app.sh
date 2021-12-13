#!/usr/bin/env bash

program=$({
	find /Applications -name "*.app" -maxdepth 2 & \
	find /System/Applications -name "*.app" -maxdepth 2 & \
	find /System/Library/CoreServices -name "*.app" -maxdepth 2 & \
  echo /Scripts/Ansible
} | fzf --layout=reverse --border)

case $program in
  "/Scripts/Ansible")
    ansible.sh
    exit
    ;;
  *)
    open $program
    exit
    ;;
esac
