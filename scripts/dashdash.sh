#!/usr/bin/env bash

endpoint=$(fzf <"$HOME/Projects/Personal/state/dashdash")

echo "$endpoint"

if [[ -n "$endpoint" ]]; then
	url="https://dashdash.io/$endpoint"
	open "$url"
fi
