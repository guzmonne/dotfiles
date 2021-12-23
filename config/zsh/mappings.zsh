# [C-x][C-e] - Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# [C-space] - Accept current suggestion
bindkey '^ ' autosuggest-accept

# [C-j] - Search history backwards
bindkey '\C-k' history-search-backward
# [C-k] - Search history forwards.
bindkey '\C-j' history-search-forward

# Key-bindings
# [C-p] Select open tmux session.
bindkey -s '^p' ' tmux-sessions.sh^M clear^M'
# [C-n] Open a new tmux session.
bindkey -s '^n' ' tmux-sessionizer.sh^M clear^M'
# [A-w] Start writing a new note in Notion.
bindkey -s '∑' ' tmux-notion.sh^M clear^M'
# [F1] - Select a service to read on dashdash.
bindkey -s '^[OP' ' dashdash.sh^M clear^M'


