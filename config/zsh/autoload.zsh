# Autho-load Rust
if [[ -n "$HOME/.cargo/env" ]]; then
	source $HOME/.cargo/env
fi

if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Setup virtualenv home.
export WORKON_HOME=$HOME/.virtualenvs

# Source the virtualenvwrapper if it exists.
if [ -f "/opt/homebrew/bin/virtualenvwrapper.sh" ]; then
  source /opt/homebrew/bin/virtualenvwrapper.sh
fi

# Tell pyenv-virtualenvwrapper to use pyenv when creating new Python environments.
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

# PyEnv configuration
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Set the pyenv shims to initialize
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
