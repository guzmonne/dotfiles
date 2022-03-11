# Completitions
# More completitions at: https://github.com/zsh-users/zsh-completions
# Configure completions for pipx
eval "$(register-python-argcomplete pipx)"
[[ /Users/gmonne/.local/google-cloud-sdk/bin/kubectl ]] && source <(kubectl completion zsh)

