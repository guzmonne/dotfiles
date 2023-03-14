#!/usr/bin/env bash
# shellcheck disable=SC2139

ROOT="$(git rev-parse --show-toplevel)"

alias coral="$ROOT/dev/coral.sh"

export ROARR_LOG=true
export NGROK_HOSTNAME=gmonne-owncoral
export HELLOSIGN_ENV=gmonne
export INVESTMENT_LIMIT_MIN=10
export ROOT="$ROOT"
export GOOGLE_APPLICATION_CREDENTIALS=$ROOT/secrets/gce-default-svc-acct_owncoral-6401c3f08e0a.json

coral backups start --fromLatest --coralEnv staging --yes --build
