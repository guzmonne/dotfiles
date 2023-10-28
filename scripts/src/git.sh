#!/usr/bin/env bash
# @name git.sh
# @version 0.1.0
# @description Some specific git commands that I personally use.
# @author Guzman Monne
# @license MIT
# @default semantic

# @cmd Create a semantic git commit from the git diff output.
semantic() {
  diff="$(git diff --staged -- . ':(exclude)package-lock.json')"

  if [[ -z "$diff" ]]; then
    echo "No changes to commit."
    return 0
  fi

  tmp="$(mktemp)"

  cat <<-EOF | tee "$tmp"
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

Begin your response with a '<context></context>' section that highlights all code changes. Next,
provide a '<thinking></thinking>' section where you meticulously explain your thought process
regarding what needs to be done. Lastly, create your reply inside the '<output></output>' section.
Your reply with no superfluous commentary—only the outcome of your reasoning, adhering to the provided guidelines.

Here is the 'git diff' output for your evaluation:

"""
$diff
"""
EOF

  c a --model claude2 - <"$tmp" \
    | awk '/<output>/,/<\/output>/' \
    | grep -vE '<output>|<\/output>' \
    | git commit -F -

  git commit --amend
}
