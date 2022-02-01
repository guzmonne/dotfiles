#!/usr/bin/env bash

clear;

while true; do
  "$@"
  sleep 2
  tput cup 0 0
done

