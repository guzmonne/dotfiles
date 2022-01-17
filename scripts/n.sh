#!/usr/bin/env bash

version=$(n list | fzf)

stow -t /usr/local/bin -d /Users/gmonne/.local/n/versions/n/versions/"$version" bin

node --version
npm --version
npx --version

