#!/usr/bin/env zsh




if [[ -n "${DEBUG:-}" ]]; then
  set -x
fi
set -e


normalize_rargs_input() {
  local arg flags

  while [[ $# -gt 0 ]]; do
    arg="$1"
    if [[ $arg =~ ^(--[a-zA-Z0-9_\-]+)=(.+)$ ]]; then
      rargs_input+=("${BASH_REMATCH[1]}")
      rargs_input+=("${BASH_REMATCH[2]}")
    elif [[ $arg =~ ^(-[a-zA-Z0-9])=(.+)$ ]]; then
      rargs_input+=("${BASH_REMATCH[1]}")
      rargs_input+=("${BASH_REMATCH[2]}")
    elif [[ $arg =~ ^-([a-zA-Z0-9][a-zA-Z0-9]+)$ ]]; then
      flags="${BASH_REMATCH[1]}"
      for ((i = 0; i < ${#flags}; i++)); do
        rargs_input+=("-${flags:i:1}")
      done
    else
      rargs_input+=("$arg")
    fi

    shift
  done
}

# Task
# Instructions
# Style Guide
# ARTICLE THEME
SELF="$(readlink -f "$(which "$0")")"
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
Summarize the following Web Page into a fully fledged article following these instructions.
1. Extract and include any code mentioned in the transcript.
2. Enhance the code if the context provided in the transcript is insufficient.
3. Present code examples using markdown code blocks with appropriate syntax highlighting.
4. Organize the content in a logical and coherent manner.
5. Add relevant headings and subheadings to improve readability.
6. Ensure technical accuracy and clarity throughout the article.
7. Include a section for key takeaways or a summary of the main points.
8. Use only text and code in the article (no additional visual elements).
- **Tone**: Professional and informative
- **Language**: Clear and concise, suitable for a technical audience
- **Length**: As long as necessary to cover the content comprehensively
Adhere to the following theme when building the article. If it's a question make sure that you answert it above all else.
EOF
)"
declare -a URLS

version() {
  echo -n "0.1.0"
}
usage() {
  printf "Uses the bravecli and mods to get information in the web and summarizes it with mods.\n"
  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  summarize [OPTIONS] [COMMAND] [COMMAND_OPTIONS]\n"
  printf "  summarize -h|--help\n"
  printf "  summarize -v|--version\n"
  printf "\n\033[4m%s\033[0m\n" "Commands:"
  cat <<EOF
  answer ........ Ask a question and have it answered by a combination of tools.
  docs-rs ....... Downloads a docs.rs site, converts it to markdown, and extracts all the references to crate references.
  search ........ Searches for a topic, then attempts to get the output
  transcribe .... Gets the transcript from a YouTube channel and attempts to create a technical article out of it.
EOF

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -h --help\n"
  printf "    Print help\n"
  printf "  -v --version\n"
  printf "    Print version\n"
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -v|--version)
        version
        exit
        ;;
      -h|--help)
        usage
        exit
        ;;
      *)
        break
        ;;
    esac
  done
  action="${1:-}"

  case $action in
    answer)
      action="answer"
      rargs_input=("${rargs_input[@]:1}")
      ;;
    craft-search-query)
      action="craft-search-query"
      rargs_input=("${rargs_input[@]:1}")
      ;;
    docs-rs)
      action="docs-rs"
      rargs_input=("${rargs_input[@]:1}")
      ;;
    search)
      action="search"
      rargs_input=("${rargs_input[@]:1}")
      ;;
    transcribe)
      action="transcribe"
      rargs_input=("${rargs_input[@]:1}")
      ;;
    -h|--help)
      usage
      exit
      ;;
    "")
      ;;
    *)
      printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid command: " "$action" >&2
      exit 1
      ;;
  esac
}
answer_usage() {
  printf "Ask a question and have it answered by a combination of tools.\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  answer [OPTIONS] [QUERY]\n"
  printf "  answer -h|--help\n"
  printf "\n\033[4m%s\033[0m\n" "Arguments:"
  printf "  QUERY\n"
  printf "    Your question.\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  --bravecli-count [<BRAVECLI-COUNT>]\n"
  printf "    Bravecli Search API result count.\n"
  printf "    [@default 20]\n"
  printf "  --e-answer-template [<E-ANSWER-TEMPLATE>]\n"
  printf "    E Answer template.\n"
  printf "    [@default puper-rag]\n"
  printf "  --e-fast-preset [<E-FAST-PRESET>]\n"
  printf "    E Fast model preset.\n"
  printf "    [@default flash]\n"
  printf "  --e-pick-url-template [<E-PICK-URL-TEMPLATE>]\n"
  printf "    E Pick URL template.\n"
  printf "    [@default brave-search]\n"
  printf "  --e-slow-preset [<E-SLOW-PRESET>]\n"
  printf "    E Slow model preset.\n"
  printf "    [@default pro]\n"
  printf "  --e-summarizer-template [<E-SUMMARIZER-TEMPLATE>]\n"
  printf "    E summarizer template.\n"
  printf "    [@default summarizer]\n"
  printf "  --freshness [<FRESHNESS>]\n"
  printf "    Query freshness. Defaults to 1 year.\n"
  printf "    [@default $(date -v -1y +%Y-%m-%d)to$(date +%Y-%m-%d)]\n"
  printf "  --intermediate-stream [<INTERMEDIATE-STREAM>]\n"
  printf "    Stream the intermediate output of the subcommands to a specific stream like "stderr".\n"
  printf "    [@default /dev/null]\n"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_answer_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -h|--help)
        answer_usage
        exit
        ;;
      *)
        break
        ;;
    esac
  done

  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      --bravecli-count)
        rargs_bravecli_count="$2"
        shift 2
        ;;
      --e-answer-template)
        rargs_e_answer_template="$2"
        shift 2
        ;;
      --e-fast-preset)
        rargs_e_fast_preset="$2"
        shift 2
        ;;
      --e-pick-url-template)
        rargs_e_pick_url_template="$2"
        shift 2
        ;;
      --e-slow-preset)
        rargs_e_slow_preset="$2"
        shift 2
        ;;
      --e-summarizer-template)
        rargs_e_summarizer_template="$2"
        shift 2
        ;;
      --freshness)
        rargs_freshness="$2"
        shift 2
        ;;
      --intermediate-stream)
        rargs_intermediate_stream="$2"
        shift 2
        ;;
      -?*)
        printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
        exit 1
        ;;
      *)
        if [[ -z "$rargs_query" ]]; then
          rargs_query=$key
          shift
        else
          printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
          exit 1
        fi
        ;;
    esac
  done
}
# Ask a question and have it answered by a combination of tools.
answer() {
  local rargs_bravecli_count
  local rargs_e_answer_template
  local rargs_e_fast_preset
  local rargs_e_pick_url_template
  local rargs_e_slow_preset
  local rargs_e_summarizer_template
  local rargs_freshness
  local rargs_intermediate_stream
  local rargs_query

  # Parse command arguments
  parse_answer_arguments "$@"

  
    
  if [[ -z "$rargs_bravecli_count" ]]; then
    rargs_bravecli_count="20"
  fi
    
    
  if [[ -z "$rargs_e_answer_template" ]]; then
    rargs_e_answer_template="puper-rag"
  fi
    
    
  if [[ -z "$rargs_e_fast_preset" ]]; then
    rargs_e_fast_preset="flash"
  fi
    
    
  if [[ -z "$rargs_e_pick_url_template" ]]; then
    rargs_e_pick_url_template="brave-search"
  fi
    
    
  if [[ -z "$rargs_e_slow_preset" ]]; then
    rargs_e_slow_preset="pro"
  fi
    
    
  if [[ -z "$rargs_e_summarizer_template" ]]; then
    rargs_e_summarizer_template="summarizer"
  fi
    
    
  if [[ -z "$rargs_freshness" ]]; then
    rargs_freshness="$(date -v -1y +%Y-%m-%d)to$(date +%Y-%m-%d)"
  fi
    
    
  if [[ -z "$rargs_intermediate_stream" ]]; then
    rargs_intermediate_stream="/dev/null"
  fi
    
	local search_query
	search_query="$(craft-search-query "$rargs_query" --e-preset "$rargs_e_slow_preset" --intermediate-stream "$rargs_intermediate_stream")"
	if [[ -z "$search_query" ]]; then
		echo "No search query found"
		return 1
	fi
	e "$rargs_query" \
		--preset "$rargs_e_fast_preset" \
		--template "$rargs_e_pick_url_template" \
		--vars "$(bravecli search "$search_query" --freshness "$rargs_freshness" --count "$rargs_bravecli_count" | jq -c)" |
		tee "$rargs_intermediate_stream" |
		awk '/<output>/,/<\/output>/' |
		grep -vE '<output>|<\/output>' |
		perl -p -e 'chomp if eof' |
		parallel --progress 'd2m -i =(puper {}) --extract-main --track-table-columns 2>/dev/null | e - --template '"$rargs_e_summarizer_template"' --preset '"$rargs_e_fast_preset" |
		tee "$rargs_intermediate_stream" |
		e - "$rargs_query" --preset "$rargs_e_fast_preset" --template "$rargs_e_answer_template"
}
craft-search-query_usage() {
  printf "Crafts a proper web search engine query from a natural language user question.\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  craft-search-query [OPTIONS] [QUERY]\n"
  printf "  craft-search-query -h|--help\n"
  printf "\n\033[4m%s\033[0m\n" "Arguments:"
  printf "  QUERY\n"
  printf "    The question to be converted.\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  --e-preset [<E-PRESET>]\n"
  printf "    E Slow model preset.\n"
  printf "    [@default pro]\n"
  printf "  --intermediate-stream [<INTERMEDIATE-STREAM>]\n"
  printf "    Stream the intermediate output of the subcommands to a specific stream like "stderr".\n"
  printf "    [@default /dev/null]\n"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_craft-search-query_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -h|--help)
        craft-search-query_usage
        exit
        ;;
      *)
        break
        ;;
    esac
  done

  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      --e-preset)
        rargs_e_preset="$2"
        shift 2
        ;;
      --intermediate-stream)
        rargs_intermediate_stream="$2"
        shift 2
        ;;
      -?*)
        printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
        exit 1
        ;;
      *)
        if [[ -z "$rargs_query" ]]; then
          rargs_query=$key
          shift
        else
          printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
          exit 1
        fi
        ;;
    esac
  done
}
# Crafts a proper web search engine query from a natural language user question.
craft-search-query() {
  local rargs_e_preset
  local rargs_intermediate_stream
  local rargs_query

  # Parse command arguments
  parse_craft-search-query_arguments "$@"

  
    
  if [[ -z "$rargs_e_preset" ]]; then
    rargs_e_preset="pro"
  fi
    
    
  if [[ -z "$rargs_intermediate_stream" ]]; then
    rargs_intermediate_stream="/dev/null"
  fi
    
	e "$rargs_query" \
		--preset "$rargs_e_preset" \
		--template search-query |
		tee "$rargs_intermediate_stream" |
		awk '/<output>/,/<\/output>/' |
		grep -vE '<output>|<\/output>' |
		perl -p -e 'chomp if eof'
}
docs-rs_usage() {
  printf "Downloads a docs.rs site, converts it to markdown, and extracts all the references to crate references.\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  docs-rs -o|--output <OUTPUT> [OPTIONS] [URL]\n"
  printf "  docs-rs -h|--help\n"
  printf "\n\033[4m%s\033[0m\n" "Arguments:"
  printf "  URL\n"
  printf "    Documentation URL.\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -o --output <OUTPUT>\n"
  printf "    Output directory for the doc files.\n"
  printf "  --force\n"
  printf "    Force overwrite of the output files.\n"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_docs-rs_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -h|--help)
        docs-rs_usage
        exit
        ;;
      *)
        break
        ;;
    esac
  done

  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      --force)
        rargs_force=1
        shift
        ;;
      -o | --output)
        rargs_output="$2"
        shift 2
        ;;
      -?*)
        printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
        exit 1
        ;;
      *)
        if [[ -z "$rargs_url" ]]; then
          rargs_url=$key
          shift
        else
          printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
          exit 1
        fi
        ;;
    esac
  done
}
# Downloads a docs.rs site, converts it to markdown, and extracts all the references to crate references.
docs-rs() {
  local rargs_force
  local rargs_output
  local rargs_url

  # Parse command arguments
  parse_docs-rs_arguments "$@"

  
  if [[ -z "$rargs_output" ]]; then
    printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Missing required option: " "output" >&2
    docs-rs_usage >&2
    exit 1
  fi
  local base_path
  local html_path
  local md_path
  base_path="${rargs_output}/$(echo -n "$rargs_url" | awk -F'https://docs.rs/|/' '
  {
    if ($NF ~ /\.html$/) {
      gsub(/\.html$/, "", $NF)
      print $2"/"$3"/"$4"/"$5
    } else {
      print $2"/"$3"/"$4"/crate"
    }
  }')"
  # If base_path has `crate` for suffix.
  if [[ "$base_path" =~ "crate$" ]]; then
    gum log --level info "Creating directory for crate"
    mkdir -p "${base_path%crate}"
  fi
  html_path="${base_path}.html"
  md_path="${base_path}.md"
  gum log --level info "html_path: $html_path"
  gum log --level info "md_path: $md_path"
  if [[ -f "$html_path" ]] && [[ -z "$rargs_force" ]]; then
    gum log --level error "File $html_path already exists. Use --force to overwrite."
    return 1
  fi
  gum log --level info "Downloading $html_path"
  puper "$rargs_url" > "$html_path"
  if [[ "$!" != "0" ]]; then
    gum log --level error "Failed to download $rargs_url"
    return 1
  fi
  gum log --level info echo "Converting HTML to MD"
  d2m -i "$html_path" --extract-main --track-table-columns 2>/dev/null |
    awk 'NF{if (blank) print ""; blank=0; print} !NF{blank++}' > "$md_path"
  if [[ "$!" != "0" ]]; then
    gum log --level error "Failed to convert $html_path to $md"
    return 1
  fi
  if [[ "$base_path" =~ "crate$" ]]; then
    gum log --level info "Extracting hrefs"
    gum log --level info "$SELF docs-rs ${rargs_url}{} --output $rargs_output"
    cat "$html_path" |
      pup 'a json{}' |
      jq '.[] | .href' -r |
      grep -E 'struct|trait|enum|type|constant' |
      grep -v '#' |
      grep -v 'http' |
      grep -v 'target-redirect' |
      sort |
      uniq |
      tee /dev/null |
      if [[ -n "$rargs_force" ]]; then
        parallel --progress "$SELF docs-rs ${rargs_url}{} --output $rargs_output" --force
      else
        parallel --progress "$SELF docs-rs ${rargs_url}{} --output $rargs_output"
      fi
    if [[ "$!" != "0" ]]; then
      gum log --level error "Failed to extract hrefs from $html_path"
      return 1
    fi
  fi
  return 0
}
search_usage() {
  printf "Searches for a topic, then attempts to get the output\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  search [OPTIONS]\n"
  printf "  search -h|--help\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -a --api [<API>]\n"
  printf "    Mods api to use.\n"
  printf "    [@default google]\n"
  printf "  -c --count [<COUNT>]\n"
  printf "    Number of results to return.\n"
  printf "    [@default 10]\n"
  printf "  -m --model [<MODEL>]\n"
  printf "    LLM API model to use.\n"
  printf "    [@default flash]\n"
  printf "  -o --offset [<OFFSET>]\n"
  printf "    Results offset.\n"
  printf "    [@default 0]\n"
  printf "  --search-prompt [<SEARCH-PROMPT>]\n"
  printf "    Search prompt\n"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_search_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -h|--help)
        search_usage
        exit
        ;;
      *)
        break
        ;;
    esac
  done

  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      -a | --api)
        rargs_api="$2"
        shift 2
        ;;
      -c | --count)
        rargs_count="$2"
        shift 2
        ;;
      -m | --model)
        rargs_model="$2"
        shift 2
        ;;
      -o | --offset)
        rargs_offset="$2"
        shift 2
        ;;
      --search-prompt)
        rargs_search_prompt="$2"
        shift 2
        ;;
      --)
        shift
        rargs_other_args+=("$@")
        break
        ;;
      -?*)
        rargs_other_args+=("$1")
        shift
        ;;
      *)
        rargs_other_args+=("$1")
        shift
        ;;
    esac
  done
}
# Searches for a topic, then attempts to get the output
search() {
  local rargs_api
  local rargs_count
  local rargs_model
  local rargs_offset
  local rargs_search_prompt

  # Parse command arguments
  parse_search_arguments "$@"

  
    
  if [[ -z "$rargs_api" ]]; then
    rargs_api="google"
  fi
    
    
  if [[ -z "$rargs_count" ]]; then
    rargs_count="10"
  fi
    
    
  if [[ -z "$rargs_model" ]]; then
    rargs_model="flash"
  fi
    
    
  if [[ -z "$rargs_offset" ]]; then
    rargs_offset="0"
  fi
    
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
			return 1
		fi
	elif [[ "$choice" == "Continue" ]]; then
		echo
	elif [[ "$choice" == "Abort" ]]; then
		return 1
	fi
	if [[ "${#URLS[@]}" == 0 ]]; then
		gum log --level error No options selected
		return 1
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
transcribe_usage() {
  printf "Gets the transcript from a YouTube channel and attempts to create a technical article out of it.\n"

  printf "\n\033[4m%s\033[0m\n" "Usage:"
  printf "  transcribe [OPTIONS] [URL]\n"
  printf "  transcribe -h|--help\n"
  printf "\n\033[4m%s\033[0m\n" "Arguments:"
  printf "  URL\n"
  printf "    YouTube URL.\n"

  printf "\n\033[4m%s\033[0m\n" "Options:"
  printf "  -a --api [<API>]\n"
  printf "    Mods api to use.\n"
  printf "    [@default google]\n"
  printf "  -m --model [<MODEL>]\n"
  printf "    LLM API model to use.\n"
  printf "    [@default gemini]\n"
  printf "  -h --help\n"
  printf "    Print help\n"
}
parse_transcribe_arguments() {
  while [[ $# -gt 0 ]]; do
    case "${1:-}" in
      -h|--help)
        transcribe_usage
        exit
        ;;
      *)
        break
        ;;
    esac
  done

  while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
      -a | --api)
        rargs_api="$2"
        shift 2
        ;;
      -m | --model)
        rargs_model="$2"
        shift 2
        ;;
      -?*)
        printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid option: " "$key" >&2
        exit 1
        ;;
      *)
        if [[ -z "$rargs_url" ]]; then
          rargs_url=$key
          shift
        else
          printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Invalid argument: " "$key" >&2
          exit 1
        fi
        ;;
    esac
  done
}
# Gets the transcript from a YouTube channel and attempts to create a technical article out of it.
transcribe() {
  local rargs_api
  local rargs_model
  local rargs_url

  # Parse command arguments
  parse_transcribe_arguments "$@"

  
    
  if [[ -z "$rargs_api" ]]; then
    rargs_api="google"
  fi
    
    
  if [[ -z "$rargs_model" ]]; then
    rargs_model="gemini"
  fi
    
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

rargs_run() {
  declare -a rargs_other_args=()
  declare -a rargs_input=()
  normalize_rargs_input "$@"
  parse_arguments "${rargs_input[@]}"
  # Call the right command action
  case "$action" in
    "answer")
      answer "${rargs_input[@]}"
      exit
      ;;
    "craft-search-query")
      craft-search-query "${rargs_input[@]}"
      exit
      ;;
    "docs-rs")
      docs-rs "${rargs_input[@]}"
      exit
      ;;
    "search")
      search "${rargs_input[@]}"
      exit
      ;;
    "transcribe")
      transcribe "${rargs_input[@]}"
      exit
      ;;
    "")
      printf "\e[31m%s\e[33m%s\e[31m\e[0m\n\n" "Missing command. Select one of " "answer, docs-rs, search, transcribe" >&2
      usage >&2
      exit 1
      ;;
    
  esac
}

rargs_run "$@"
