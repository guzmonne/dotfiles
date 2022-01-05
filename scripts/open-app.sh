#!/usr/bin/env bash

program=$({
	find /Applications -name "*.app" -maxdepth 2 & \
	find /System/Applications -name "*.app" -maxdepth 2 & \
	find /System/Library/CoreServices -name "*.app" -maxdepth 2 & \
  echo /Scripts/Ansible & \
  echo /Scripts/Kubectl\ Context & \
  echo /Scripts/Google\ Configuration & \
  echo /Scripts/Files & \
} | fzf --layout=reverse --border)

case $program in
  "/Scripts/Kubectl Context")
    kubectl context
    exit
    ;;
  "/Scripts/Google Configuration")
    google-credentials.sh
    exit
    ;;
  "/Scripts/Files")
    files.sh
    exit
    ;;
  "/Scripts/Ansible")
    ansible.sh
    exit
    ;;
  *)
    open $program
    exit
    ;;
esac
