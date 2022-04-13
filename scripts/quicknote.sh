#!/usr/bin/env bash

default_title=$(date -u +"%Y-%m-%dT%H:%M")

nvim \
  -c "ZkNew { title = vim.fn.input('Title: "$default_title"')}"

