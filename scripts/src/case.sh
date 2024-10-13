#!/usr/bin/env bash
# shellcheck disable=SC2154

# @describe Run string case conversions.
# @author Guzmán Monné
# @version 1.0.0

# @cmd Converts a string to snake case.
# @arg string The string to convert.
to-snake() {
	echo "$rargs_string" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]'
}

# @cmd Converts a string to dash case.
# @arg string The string to convert.
to-dash() {
	to-snake "$rargs_string" | sed 's|_|-|g'
}

# @cmd Converts a string to camel case.
# @arg string The string to convert.
to-camel() {
	to-dash "$rargs_string" | perl -pe 's/-(.)/\u$1/g'
}
