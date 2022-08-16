#!/usr/bin/env bash

# @describe Manage Jenkins server through a REST API

servers_credentials_directory="$HOME/Projects/Personal/secrets/jenkins"

# @cmd get the list of available servers
# @option -d --directory server credentials path
# @flag -f --fzf pipe the list of available servers through fzf
servers() {
	if [[ -z "$argc_path" ]]; then
		argc_path="$servers_credentials_directory"
	fi
	_servers "$argc_path" "$argc_fzf"
}

# $cmd get the list of available servers
# $arg secret_credentials_directory* path to the secrets credentials directory
# $arg fzf fzf flag
_servers() {
	servers=$(/bin/ls "$1" | tr -s ' ' '\n')
	if [[ "$2" -gt 0 ]]; then
		fzf-tmux -p 40%,30% <<<"$servers"
		exit
	fi
	echo "$servers"
}

# @cmd explore Jenkins jobs from the root of the project
# @option -d --directory server credentials path
# @option -s --server url for the Jenkins server
explore() {
	if [[ -z "$argc_path" ]]; then
		argc_path="$servers_credentials_directory"
	fi
	if [[ -z "$argc_server" ]]; then
		argc_server=$(_servers "$argc_path" 1)
	fi
	url="$argc_server/"
	credentials=$(cat "$argc_path/$argc_server")
	_explore "$url" "$credentials" "$argc_server"
}

# $cmd explore the jobs for the provided endpoint
# $arg endpoint enpoint from where to list the jobs.
# $arg credentials server credentials
# $arg server server url
_explore() {
	body=$(https POST "$1""api/json" --auth "$2")
	jobs=$(
		echo "$body" |
			jq -r '.jobs[] | (.name + " " + .url)' 2>/dev/null | column -t
	)
	if [[ -z "$jobs" ]]; then
		echo "$body" | jless
		exit
	fi
	next=$(echo "$jobs" | fzf --header 'Press CTRL-C to exit the explorer')
	if [[ -z "$next" ]]; then
		exit
	else
		echo "$next"
	fi
	_explore "$(echo "$next" | awk '{print $2}')" "$2"
}

# Run argc
eval "$(argc "$0" "$@")"
