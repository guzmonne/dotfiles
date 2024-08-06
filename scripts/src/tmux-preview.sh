#!/usr/bin/env bash
# shellcheck disable=SC2154

# @name tmux-preview
# @version 0.1.0
# @description Display preview of tmux windows/panes. Meant for use in fzf previews.
# @author Guzmán Monné

# @cmd Display a single session
# @arg session-name Name of the session.
# @arg server=default Tmux server socket name.
display-session() {
	local session_id

	session_id="$(tmux -L "$rargs_server" ls -F '#{session_id}' -f "#{==:#{session_name},${rargs_session_name}}")"

	if [[ -z $session_id ]]; then
		echo "Unknown session: ${rargs_session_name}"
		return 1
	fi

	tmux -L "$rargs_server" capture-pane -ep -t "${session_id}"
}

# @cmd Display a full tree, with selected session highlighted.
# @arg server=default Tmux server socket name.
display-tree() {
	local session_info
	local magenta="\033[35m"
	local cyan="\033[36m"
	local bold="\033[1m"
	local reset="\033[0m"

	tmux -L "$rargs_server" ls -F'#{session_id}' | while read -r s; do
		S=$(tmux -L "$rargs_server" ls -F'#{session_id}#{session_name}: #{T:tree_mode_format}' | grep ^"$s")
		session_info="${S##"$s"}"

		echo -e "${cyan}${bold}$session_info${reset}"
		# Display each window
		tmux -L "$rargs_server" lsw -t"$s" -F'#{window_id}' | while read -r w; do
			W=$(tmux -L "$rargs_server" lsw -t"$s" -F'#{window_id}#{T:tree_mode_format}' | grep ^"$w")
			echo -e "  ${magenta}﬌ ${reset}${W##"$w"}"
		done
	done
}
