#!/usr/bin/env bash
# shellcheck disable=SC2154
# @name utils
# @version 0.1.0
# @description A list of useful cli commands
# @author "Guzmán Monné <guzman.monne@cloudbridge.com.uy>"

# @cmd Prints the current battery level
battery() {
	pmset -g batt | grep -E "([0-9]+\%).*" -o --colour=auto | cut -f1 -d';'
}

# @cmd List out all the currently LISTENING ports.
listening-ports() {
	lsof -i -P -n | grep LISTEN
}

# @cmd List out the PID for the process that is currently listening on the provided port.
# @arg port! Port number to check
# @option -v --ip-version[=IPv4|IPv6] IP version to use
pid-port() {
	line="$(listening-ports | grep "$rargs_ip_version" | grep ":$rargs_port")"
	pid=$(echo "$line" | awk '{print $2}')
	pid_name=$(echo "$line" | awk '{print $1}')

	# If there's nothing running, exit
	[[ -z "$pid" ]] && exit 0

	# output the process name to stderr so it won't be piped along
	echo >&2 -e "$pid_name"

	# print the process id. It can be piped, for example to pbcopy
	echo -e "$pid"
}

# @cmd Kills the process currently listening on the provided port.
# @arg port! Port number to check
# @option -v --ip-version[=IPv4|IPv6] IP version to use
kill-port() {
	pid-port "$@" | xargs kill -9
}
