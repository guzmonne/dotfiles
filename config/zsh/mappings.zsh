# [Space] - Don't do history expansion.
bindkey ' ' magic-space

# [C-x][C-e] - Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# [C-o] - Accept and infer next history
bindkey -M menuselect '^o' accept-and-infer-next-history
