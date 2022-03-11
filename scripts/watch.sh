#!/usr/bin/env bash

clear;

while true; do
  screen=$("$@")
  clear
  printf "$screen"
  sleep 2
done

