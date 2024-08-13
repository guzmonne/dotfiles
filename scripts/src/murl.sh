#!/usr/bin/env bash
# shellcheck disable=SC2154
# shellcheck disable=SC2016
# @name murl
# @version 0.1.0
# @description A simple wrapper that uses curl and mods for multiple purposes.
# @author Guzmán Monné
# @default aws-docs
# @rule no-first-option-help

AWS_DOCS_PROMPT='<system-prompt>
<task>Convert the given HTML document to markdown format</task>
<instructions>
  <step>Remove non-essential HTML elements:
    <sub-step>Remove menus, tabs, navigation links, and similar UI components</sub-step>
    <sub-step>Preserve main content and structure</sub-step>
  </step>
  <step>Convert content to markdown:
    <sub-step>Use # for top-level headings, then start with ## for subsequent levels</sub-step>
    <sub-step>Convert HTML tables to markdown tables</sub-step>
    <sub-step>Convert HTML lists (ordered and unordered) to markdown lists</sub-step>
    <sub-step>Ignore inline styling, focus on content and structure</sub-step>
  </step>
  <step>Handle code-related content:
    <sub-step>Enclose code blocks in triple backticks (```) with appropriate language specification</sub-step>
    <sub-step>Use single backticks (`) for inline code references</sub-step>
  </step>
  <step>If a `Contents` section exists:
    <sub-step>Move it to the top of the document</sub-step>
    <sub-step>Ensure correct links to the referenced sections in the text</sub-step>
  </step>
  <step>For images and other media:
    <sub-step>Preserve the links in markdown format</sub-step>
  </step>
</instructions>
</system-prompt>'

# @cmd Gets an AWS documentation page and formats it as Markdown.
# @arg url Documentation site URL.
# @option -a --api=anthropic Mods LLM API to use.
# @option -m --model=sonnet Mods LLM Model to use.
# @option -s --selector="#main-col-body" Main selector to filter the body of the curl request.
# @option -p --prompt AWS Docs LLM prompt.
# @dep curl,pup,mods
aws-docs() {
	if [[ -z "$rargs_prompt" ]]; then
		rargs_prompt="$AWS_DOCS_PROMPT"
	fi

	curl -skL "$rargs_url" |
		pup "$rargs_selector" |
		mods \
			--api "$rargs_api" \
			--model "$rargs_model" \
			"$rargs_prompt"
}
