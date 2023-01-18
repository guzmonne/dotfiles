# Completitions
# More completitions at: https://github.com/zsh-users/zsh-completions
# Configure completions for pipx
# eval "$(register-python-argcomplete pipx)"
[[ /Users/gmonne/.local/google-cloud-sdk/bin/kubectl ]] && source <(kubectl completion zsh)

# aws cli completions
if [[ -x "$(command -v aws)" ]]; then
  autoload bashcompinit && bashcompinit
  autoload -Uz compinit && compinit
  complete -C '/opt/homebrew/Cellar/awscli/2.9.15/bin/aws_completer' aws
fi
# pandoc cli completions
if [[ -x "$(command -v pandoc)" ]]; then
  eval "$(pandoc --bash-completion)"
fi

# dasel cli completions
export fpath=(~/zsh/site-functions $fpath)
mkdir -p ~/zsh/site-functions
dasel completion zsh > ~/zsh/site-functions/_dasel
compinit
