# More completitions at: https://github.com/zsh-users/zsh-completions
# Configure completions for pipx
eval "$(register-python-argcomplete pipx)"
source <(kubectl completion zsh)

# Do not autoselect the first completion entry
unsetopt menu_complete
unsetopt flowcontrol

# Show completion menu on successive tab press.
setopt auto_menu
setopt complete_in_word
setopt always_to_end




