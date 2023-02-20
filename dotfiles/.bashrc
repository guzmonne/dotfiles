#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2155

# source "$HOME/.config/zsh/history.zsh"
source "$HOME/.config/zsh/exports.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/prompt.zsh"
# source "$HOME/.config/zsh/mappings.zsh"
# source "$HOME/.config/zsh/completions.zsh"
# source "$HOME/.config/zsh/autoload.zsh"
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"





