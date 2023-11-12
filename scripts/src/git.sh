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
	diff="$(git diff --staged -- . ':(exclude)package-lock.json')"

	if [[ -z "$diff" ]]; then
		echo "No changes to commit."
		return 0
	fi

	tmp="$(mktemp)"

	# Create the master prompt using `cat` and `tee`. Also, remove any leading spaces from each line.
	cat <<-'EOF' | sed 's/^[ \t]*//' | tee "$tmp"
		  Consider the following text as your guide to creating a semantic git commit from the given 'git diff' output.

		  Your semantic commit should start with one of these prefixes:

		  - feat: Introducing a new feature
		  - fix: Repairing a bug
		  - docs: Changes solely involving documentation
		  - style: Modifications that don't impact the underlying code
		  - refactor: Adjustments to code that don't correct a bug or introduce a new feature
		  - perf: Modifications to improve performance
		  - test: The addition of missing tests or correction of existing ones
		  - build: Alterations affecting the build system or external dependencies
		  - ci: Revisions to Continuous Integration configuration files and scripts
		  - chore: Other changes that don't affect source or test files

		  If a single semantic commit does not precisely categorize the changes, write a list of all required
		  semantic commits.

		  Above all, try to identify the main service affected by these changes. Include this service in your
		  semantic commit in parentheses. For instance, if changes have been made to the 'sessionizer'
		  service, you should write '(sessionizer)' following the prefix. If you've decided on the 'feat'
		  prefix, the final semantic commit would read as 'feat(sessionizer): ...'.

		      Your response should be returned in `XML` format. The following is an example of a valid response:

		      ```xml
		      <context>
		      ...
		      </context>
		      <thinking>
		      ...
		      </thinking>
		      <output>
		      ...
		      </output>
		      ```

		  Begin your response with a '<context></context>' section that highlights all code changes. Next,
		  provide a '<thinking></thinking>' section where you meticulously explain your thought process
		  regarding what needs to be done. Lastly, create your reply inside the '<output></output>' section.
		  Your reply with no superfluous commentary—only the outcome of your reasoning, adhering to the provided guidelines.

		  Here is the 'git diff' output for your evaluation:

		  """
		  $diff
		  """
	EOF

	response="$(mktemp)"
	c o --stream - <"$tmp" | tee "$response"

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
