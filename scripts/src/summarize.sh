#!/usr/bin/env bash
# shellcheck disable=SC2154
# @name summarize
# @version 0.1.0
# @description Uses the bravecli and mods to get information in the web and summarizes it with mods.
# @author "Guzmán Monné <guzman.monne@cloudbridge.com.uy>"
# @deps bravecli|mods|jq|parallel|mdka-cli|glow|yt|gum

TRANSCRIPT_PROMPT="$(
	cat <<EOF
<prompt>
  <task>Transform a YouTube video transcript into a comprehensive technical article in markdown format. Thinking step-by-step, you'll first draft a small outline of the article based on the transcription before delivering the complete article.</task>
  <output>
    <article-structure>
      <section>Introduction</section>
      <section>Main content (based on the transcript)</section>
      <section>Code examples (extracted and potentially enhanced)</section>
      <section>Key takeaways</section>
      <section>Conclusion</section>
    </article-structure>
    <format>Markdown</format>
  </output>
  <instructions>
    <step>Extract and include any code mentioned in the transcript</step>
    <step>Enhance the code if the context provided in the transcript is insufficient</step>
    <step>Present code examples using markdown code blocks with appropriate syntax highlighting</step>
    <step>Organize the content in a logical and coherent manner</step>
    <step>Add relevant headings and subheadings to improve readability</step>
    <step>Ensure technical accuracy and clarity throughout the article</step>
    <step>Include a section for key takeaways or a summary of the main points</step>
    <step>Use only text and code in the article (no additional visual elements)</step>
  </instructions>
  <style-guide>
    <tone>Professional and informative</tone>
    <language>Clear and concise, suitable for a technical audience</language>
    <length>As long as necessary to cover the content comprehensively</length>
  </style-guide>
</prompt>
EOF
)"

# @cmd Gets the transcript from a YouTube channel and attempts to create a technical article out of it.
# @arg url YouTube URL.
# @option -a --api=google Mods api to use.
# @option -m --model=gemini LLM API model to use.
transcribe() {
	if [[ -z "$rargs_url" ]]; then
		rargs_url="$(gum input \
			--placeholder="YouTube URL" \
			--prompt=">>> " \
			--cursor.mode="blink" \
			--width=80 \
			--prompt.foreground="yellow" \
			--cursor.foreground="blue" \
			--header="Please provide the YouTube URL from the video you want to download the transcript" \
			--header.foreground="green")"
	fi

	yt transcript "$rargs_url" | mods --api "$rargs_api" --model "$rargs_model" "$TRANSCRIPT_PROMPT"
}

SIMPLE_SUMMARIZATION_SYSTEM_PROMPT="$(
	cat <<EOF
<prompt>
  <task>Summarize the following Web Page, rendered as markdown to enhance its contents.</task>
  <instructions>
    <step>Extract and include any code mentioned in the transcript</step>
    <step>Enhance the code if the context provided in the transcript is insufficient</step>
    <step>Present code examples using markdown code blocks with appropriate syntax highlighting</step>
    <step>Organize the content in a logical and coherent manner</step>
    <step>Add relevant headings and subheadings to improve readability</step>
    <step>Ensure technical accuracy and clarity throughout the article</step>
    <step>Include a section for key takeaways or a summary of the main points</step>
    <step>Use only text and code in the article (no additional visual elements)</step>
  </instructions>
  <style-guide>
    <tone>Professional and informative</tone>
    <language>Clear and concise, suitable for a technical audience</language>
    <length>As long as necessary to cover the content comprehensively</length>
  </style-guide>
</prompt>
EOF
)"

COMPLEX_SUMMARIZATION_SYSTEM_PROMPT="$(
	cat <<EOF
## Task

Summarize the following Web Page into a fully fledged article following these instructions.

## Instructions

1. Extract and include any code mentioned in the transcript.
2. Enhance the code if the context provided in the transcript is insufficient.
3. Present code examples using markdown code blocks with appropriate syntax highlighting.
4. Organize the content in a logical and coherent manner.
5. Add relevant headings and subheadings to improve readability.
6. Ensure technical accuracy and clarity throughout the article.
7. Include a section for key takeaways or a summary of the main points.
8. Use only text and code in the article (no additional visual elements).

## Style Guide

- **Tone**: Professional and informative
- **Language**: Clear and concise, suitable for a technical audience
- **Length**: As long as necessary to cover the content comprehensively

## ARTICLE THEME

Adhere to the following theme when building the article. If it's a question make sure that you answert it above all else.
EOF
)"

declare -a URLS

# @cmd Searches for a topic, then attempts to get the output
# @option --search-prompt Search prompt
# @option -a --api=google Mods api to use.
# @option -m --model=flash LLM API model to use.
# @option -c --count=10 Number of results to return.
# @option -o --offset=0 Results offset.
# @any <BRAVECLI_OPTIONS> Additional options to pass to the 'bravecli' app.
search() {
	local choice
	local choices
	local results
	local tmp
	local url

	if [[ -z "$rargs_search_prompt" ]]; then
		rargs_search_prompt="$(gum input \
			--placeholder="Search Prompt" \
			--prompt=">>> " \
			--cursor.mode="blink" \
			--width=80 \
			--prompt.foreground="yellow" \
			--cursor.foreground="blue" \
			--header="What are you looking for?" \
			--header.foreground="green")"
	fi

	# shellcheck disable=SC2046
	results="$(bravecli search "$rargs_search_prompt" "${rargs_other_args[@]}" $(if [[ "$rargs_offset" != "0" ]]; then echo --offset "$rargs_offset"; fi) --count "$rargs_count")"
	tmp="$(mktemp -d)"

	summary="$(echo "$results" | jq '.summary')"

	echo '# Brave Web Search Results' | glow
	echo

	{
		if [[ -n "$summary" ]] && [[ "$summary" != "null" ]]; then
			echo '## Brave Summary'
			echo
			# shellcheck disable=SC2016
			printf '```\n%s\n```' "$summary"
			echo
		fi
		jq -r '[
  .web.results[] |
  { title: .title, url: .url, description: .description }
] | to_entries[] |
"## [\(.key) - \(.value.title)](\(.value.url))\n\n\(.value.description)\n"' <(echo "$results")
	} | glow

	echo --- | glow

	if [[ $((rargs_offset + 1)) -ge 10 ]]; then
		echo "> No more results pages" | glow
		choice="$(gum choose --header 'Based on the following results, what do you want to do next?' "Pick" "Continue" "Abort")"
	else
		choice="$(gum choose --header 'Based on the following results, what do you want to do next?' "Pick" "Next" "Continue" "Abort")"
	fi

	if [[ "$choice" == "Next" ]]; then
		search --search-prompt "$rargs_search_prompt" --api "$rargs_api" --model "$rargs_model" --count "$rargs_count" --offset "$((rargs_offset + 1))"
		return "$?"
	elif [[ "$choice" == "Pick" ]]; then
		choices="$(gum input --header 'Which ones? [space separated list of indexes starting from 0]')"
		for choice in $choices; do
			url="$(jq -r '.web.results['"$choice"'] | .url' <(echo "$results"))"
			URLS+=("$url")
		done
		if [[ $((rargs_offset + 1)) -ge 10 ]]; then
			echo "> No more results pages" | glow
			choice="$(gum choose --header "Added $choices. What do you want to do next?" "Continue" "Abort")"
		else
			choice="$(gum choose --header "Added $choices. What do you want to do next?" "See more options" "Continue" "Abort")"
		fi

		if [[ "$choice" == "See more options" ]]; then
			search --search-prompt "$rargs_search_prompt" --api "$rargs_api" --model "$rargs_model" --count "$rargs_count" --offset "$((rargs_offset + 1))"
			return "$?"
		elif [[ "$choice" == "Continue" ]]; then
			echo
		elif [[ "$choice" == "Abort" ]]; then
			exit 1
		fi
	elif [[ "$choice" == "Continue" ]]; then
		echo
	elif [[ "$choice" == "Abort" ]]; then
		exit 1
	fi

	if [[ "${#URLS[@]}" == 0 ]]; then
		gum log --level error No options selected
		exit 1
	fi

	gum log --level info Running summary for selected "${#URLS[@]}" results.

	script="$(
		cat <<EOF
export FILE="$tmp/\$(echo -n {} | base64)";

puper {} > \$FILE;

bunx d2m@latest -i \$FILE --extract-main --track-table-columns -meta extended 2>/dev/null |
  mods --no-cache --api "$rargs_api" --model "$rargs_model" "$SIMPLE_SUMMARIZATION_SYSTEM_PROMPT"
EOF
	)"

	echo "${URLS[@]}" |
		xargs -n1 |
		parallel -j 3 --progress "$script" |
		mods --no-cache --api "$rargs_api" --model "$rargs_model" "$COMPLEX_SUMMARIZATION_SYSTEM_PROMPT$rargs_search_prompt"
}
