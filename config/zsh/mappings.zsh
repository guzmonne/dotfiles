# [C-x] - Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x' edit-command-line

# [C-space] - Accept current suggestion
bindkey '^ ' autosuggest-accept

# [C-j] - Search history backwards
bindkey '\C-k' history-search-backward
# [C-k] - Search history forwards.
bindkey '\C-j' history-search-forward
# [C-h] - Use a custom history command search powered by fzf
bindkey -s '\C-g' 'history 1 | fzf-search.sh^M'
# [C-f] - Use a custom tmux pane command search powered by fzf
bindkey -s '\C-f' 'tmux capture-pane -pS -99999 | fzf-search.sh^M'

# Key-bindings
# [C-p] Select open tmux session.
bindkey -s '^p' 'tmux-sessions.sh^M ^M'
# [C-n] Open a new tmux session.
bindkey -s '^n' 'tmux-sessionizer.sh^M ^M'
# [C-Tab] Toggles to the previous session
bindkey -s '^t' 'tmux-toggle.sh^M ^M'
# [F1] Creates a new quick note
# bindkey -s '^[OP' 'quicknote.sh^M ^M'
# [A-w] Start writing a new note in Notion.
bindkey -s '∑' 'tmux-notion.sh^M ^M'
# [F1] - Select a service to read on dashdash.
# bindkey -s '^[OR' 'dashdash.sh^M ^M'

# [C-b] - Move backwards one word.
bindkey '\C-e' backward-word
# [C-w] - Move forwards one word.
bindkey '\C-w' forward-word
