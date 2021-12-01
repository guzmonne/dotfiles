#!/usr/bin/env bash

endpoint=$(cat $HOME/Projects/Personal/state/dashdash | fzf)

echo $endpoint

if [ ! -z "$endpoint" ]; then
	url="https://dashdash.io/$endpoint"
	open $url
fi

