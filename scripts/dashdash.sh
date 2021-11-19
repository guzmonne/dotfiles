#!/usr/bin/env bash

endpoint=$(cat $HOME/Projects/Personal/state/dashdash | fzf)

url="https://dashdash.io/$endpoint"

open $url

