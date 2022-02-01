#!/usr/bin/env bash

version=$(n list | fzf)

rm -f /usr/local/bin/node
rm -f /usr/local/bin/npm
rm -f /usr/local/bin/npx

stow -t /usr/local/bin -d /Users/gmonne/.local/n/versions/n/versions/"$version" bin

node --version
npm --version
npx --version

