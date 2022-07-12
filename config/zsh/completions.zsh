# Completitions
# More completitions at: https://github.com/zsh-users/zsh-completions
# Configure completions for pipx
# eval "$(register-python-argcomplete pipx)"
[[ /Users/gmonne/.local/google-cloud-sdk/bin/kubectl ]] && source <(kubectl completion zsh)

# aws cli completions
if [[ -x "$(command -v aws)" ]]; then
  complete -C '/usr/local/bin/aws_completer' aws
fi
# pandoc cli completions
if [[ -x "$(command -v pandoc)" ]]; then
  eval "$(pandoc --bash-completion)"
fi
