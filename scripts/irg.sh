#!/usr/bin/env zsh

# Use fzg as a selector interface for RipGrep.
# Every time you type the process will restart with the updated query string denoted by `{q}`.
# We use the `--disabled` flag so that fzf doesn't do additional filtering.

INITIAL_QUERY=""
RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"

FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY' | column -s: -t"

line=$(fzf --bind "change:reload:$RG_PREFIX {q} | column -s: -t || true" \
    --ansi --disabled --query "$INITIAL_QUERY" \
    --height=50% --layout=reverse)

echo $line

