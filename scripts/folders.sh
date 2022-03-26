#!/usr/bin/env bash

# This file scours through my most important working folders and pipes
# them through `fzf`. The returning value can be used as input for other
# scripts. For example, to generate new tmux windows or sessions.
{
  find ~ -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects -mindepth 1 -maxdepth 1 -type d & \
  find ~/Projects -mindepth 2 -maxdepth 3 -type d | grep -E ".*/Projects/[^/]*/[^/]*$" & \
  find ~/Projects -mindepth 2 -maxdepth 4 -type d | grep -E ".*/Projects/[^/]*/[^/]*/branches/"  & \
} | sort -u | fzf
