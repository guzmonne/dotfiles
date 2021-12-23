# [C-x][C-e] - Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# [C-space] - Accept current suggestion
bindkey '^ ' autosuggest-accept

bindkey '\C-k' history-search-backward
bindkey '\C-j' history-search-forward

