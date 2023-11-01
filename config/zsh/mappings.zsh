# [C-x] - Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x' edit-command-line

# [C-space] - Accept current suggestion
bindkey '\C-y' autosuggest-accept

# This should set the smart history (According to GPT-3)
setopt HIST_IGNORE_ALL_DUPS
# [C-k] - Search history backwards
bindkey '\C-k' history-substring-search-up
# [C-j] - Search history forwards.
bindkey '\C-j' history-substring-search-down

# Key-bindings
# [C-p] Select open tmux session.
# bindkey -s '^p' 'sessionizer sessions go^M'
# [C-n] Open a new tmux session.
# bindkey -s '^n' 'sessionizer sessions new ^M'

# [C-b] - Move backwards one word.
bindkey '\C-e' backward-word
# [C-w] - Move forwards one word.
bindkey '\C-w' forward-word
