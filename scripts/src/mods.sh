#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC2090
# shellcheck disable=SC2016
# @name mods
# @version 0.1.0
# @description A script built around `rargs` to extend its functionality.
# @author Guzmán Monné
# @env OPENAI_API_KEY! Your OpenAI API key.
# @any <MODS_ARGUMENTS> Optional arguments to pass to "mods".

mods="$HOME/.local/bin/mods"
textarea="$HOME/.local/bin/textarea.sh"

# @cmd Print an alert message
# @arg message Message to print inside the alert
# @private
alert() {
	gum style "$rargs_alert" \
		--foreground="blue" \
		--background="black" \
		--border="rounded" \
		--border-foreground="green" \
		--align="center" \
		--height=3 \
		--width=50 \
		--margin="1" \
		--padding="1" \
		--bold \
		--underline >&2
}

# @cmd Input box
# @option -p --placeholder Input placeholder
# @option -h --header Input header
# @option -P --prompt Input prompt
# @private
input() {
	gum input \
		--placeholder="$rargs_placeholder" \
		--prompt="$rargs_prompt" \
		--header="$rargs_header" \
		--width=40 \
		--char-limit=400
}

# @cmd Gets the user prompt
# @private
get_prompt() {
	prompt="$($textarea)"

	if [[ -z "$prompt" ]]; then
		exit 1
	fi

	echo -n "$prompt"
}

# @cmd Start a new mods session with the selected role.
# @option -r --role
role() {
	if [[ -z "$rargs_role" ]]; then
		rargs_role="$(roles)"
	fi

	prompt="$(get_prompt)"

	$mods --api copilot --role "$rargs_role" "$prompt"
}

# @cmd Start a chat with an Agent inside NeoVim
# @arg stdin Prompt context. Pass in '-' to read from 'stdin'.
# @option -a --agent
# @flag --kill-window Close tmux window on exit
gp() {
	if [[ -z "$rargs_agent" ]]; then
		local lua_file

		lua_file="$HOME/.config/nvim/lua/plugins/gp.lua"
		rargs_agent="$(grep -E 'name = ' "$lua_file" | awk '{print $3}' | tr -d '",' | fzf)"
	fi

	if [[ "$rargs_stdin" == "-" ]]; then
		rargs_stdin="$(cat | sed -r "s/\x1b\[[0-9;]*m//g")"
	fi

	# Use a temporary file for the processed content
	local tmpfile

	tmpfile="$(mktemp /tmp/nvim_buffer_cleaned.XXXXXX)"

	# Save the input to the tmpfile
	echo "$rargs_stdin" >"$tmpfile"

	# Process the input and open NeoVim directly, ensuring it doesn't suspend.
	nvim -c "GpChatNew" \
		-c "call append(line('$')-1, readfile('$tmpfile'))" \
		-c "GpAgent $rargs_agent" \
		-c "normal! Gdd" \
		-c "startinsert"

	rm -Rf "$tmpfile"

	if [[ -n "$rargs_kill_window" ]]; then
		tmux kill-window
	fi
}

# @cmd Start a new mods session
# @option -t --title Session title
new() {
	if [[ -z "$rargs_title" ]]; then
		rargs_title="$(input \
			-P "New Title: " \
			-h "Please enter a new title for the 'mods' session" \
			-p "E.g. Bashy")"
	fi

	if [[ -z "$rargs_title" ]]; then
		alert "The session title name is required"
		return 1
	fi

	prompt="$(get_prompt)"

	$mods --api copilot --title "$rargs_title" "$prompt"
}

# @cmd Selects an existing role
# @private
roles() {
	local settings_file

	settings_file="$($mods --dirs | head -n1 | awk -F':' '{print $2}' | xargs | sed 's| |\\ |g')/mods.yml"

	$mods --list-roles 2>&1 | fzf \
		--preview 'yq '"'"'.roles.{}[] | .'"'"' -r '"$settings_file" \
		--bind ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up \
		--preview-window=right:60% \
		--height 100%
}

# @cmd Selects an existing session
# @private
session() {
	session="$(
		$mods --list --raw 2>&1 | fzf \
			-m \
			--preview 'mods -s "$(echo -n {} | awk '"'"'{print $1}'"'"')" --raw | bat -l markdown' \
			--bind ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up \
			--preview-window=right:60% \
			--height 100%
	)"
	echo "$session"
}

# @cmd Continue an existing session
cont() {
	line="$(session)"
	id="$(echo -n "$line" | awk -F'\t' '{print $1}' | tr -d ' ')"
	title="$(echo -n "$line" | awk -F'\t' '{print $2}')"

	prompt="$(get_prompt)"

	$mods --api copilot --continue "$id" --title "$title" "$prompt"
}

show() {
	line="$(session)"
	id="$(echo -n "$line" | awk -F'\t' '{print $1}' | tr -d ' ')"

	$mods -s "$id"
}

# @option -o --option Option to chose
root() {
	if [[ -z "$rargs_option" ]]; then
		rargs_option="$(echo -e "1. Select Agent\n2. Start a new session.\n3. Continue an existing session.\n4. Show existing session.\n5. Mods" | fzf)"
	fi

	if [[ -z "$rargs_option" ]]; then
		alert "No option selected"
		return 1
	fi

	option="$(echo -n "$rargs_option" | awk -F'.' '{print $1}')"

	case "$option" in
	"1")
		gp --kill-window
		;;
	"2")
		new
		;;
	"3")
		cont
		;;
	"4")
		show
		;;
	"5")
		role
		;;
	*)
		alert "No option selected"
		return 1
		;;
	esac
}
