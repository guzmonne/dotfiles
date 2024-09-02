#!/usr/bin/env bash
# @name git.sh
# @version 0.1.0
# @description Some specific git commands that I personally use.
# @author Guzman Monne
# @license MIT
# @default semantic

# @cmd Create a semantic git commit from the git diff output.
# @flag --no-git-commit Don't run the git commit command automatically.
semantic() {
	local response

	response="$(mktemp)"

	git diff --staged -- . ':(exclude)package-lock.json' ':(exclude)lazy-lock.json' ':(exclude)*.lock' |
		e --template git-semantic-commit --vars "$(jo branch="$(git branch --show-current)")" --preset sonnet |
		tee "$response"

	if [[ -z "$rargs_no_git_commit" ]]; then
		commit="$(awk '/<output>/,/<\/output>/' "$response" | grep -vE '<output>|<\/output>' | perl -p -e 'chomp if eof')"

		printf '%s' "$commit" | git commit -F -

		git commit --amend
	fi
}

# @cmd Simplifies the process of staging files for a commit.
# @flag --all Add all files
# @flag --no-git-commit Don't run the git commit command automatically.
add() {
	if [[ -n "$rargs_all" ]]; then
		git add -A
	else
		# Output the list of modified files
		modified_files="$(git ls-files --modified)"

		# Use fzf for interactive selection
		mapfile -t selected_files < <(echo "$modified_files" | fzf -m \
			--preview 'git diff -- {}' \
			--preview-window=up:80% \
			--height 100% \
			--border)

		for file in "${selected_files[@]}"; do
			git add "$file"
		done
	fi

	if [[ -z "$rargs_no_git_commit" ]]; then
		semantic
	fi
}
