#!/usr/bin/env bash
# shellcheck disable=SC2154
# @name mollama
# @version 0.1.0
# @description A wrapper around the ollama binary exposed by an external machine invoked through SSH.
# @author

# @option -s --server=M2 The SSH server to connect to.
# @option -m --model=codebooga The model to use.
# @arg prompt The prompt to use. Will try to read from `stdin` if not provided.
root() {
	local random_port

	# Generate a random port number
	random_port="$(shuf -i 20000-30000 -n 1)"

	if ssh -q "$rargs_server" exit; then
		if [ -t 0 ]; then
			# No input from stdin, so just run the command directly
			data="$(jo model="$rargs_model" prompt="$*")"
		else
			# Input from stdin, so pass it through to the ssh command
			data="$(jo model="$rargs_model" prompt="$(cat -)")"
		fi
		ssh "$rargs_server" curl -sXPOST "http://localhost:11434/api/generate" -d "$data"
	else
		echo "Can't SSH into the $rargs_server machine"
	fi
}
