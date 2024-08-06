#!/usr/bin/env bash

spinner() {
	local pid=$1
	local delay=0.1
	local spinstr='|/-\'
	while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
		local temp=${spinstr#?}
		printf " [%c]  " "$spinstr"
		local spinstr=$temp${spinstr%"$temp"}
		echo -en "\b\b\b\b\b\b"
		sleep $delay
	done
	printf "    \b\b\b\b"
}

(
	# Your long-running command here
	sleep 5
) &

spinner $!
echo "Done!"
