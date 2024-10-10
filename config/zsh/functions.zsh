# Adds a plugin.
function zsh_add_plugin() {
  ORG=$(echo $1 | cut -d "/" -f 1)
  PLUGIN=$(echo $1 | cut -d "/" -f 2)
  if [ ! -d "$HOME/.config/repos/$ORG/$PLUGIN" ]; then
    git clone --depth=1 "git@github.com:$1.git" "$HOME/.config/repos/$ORG/$PLUGIN"
  fi

  if [ -f "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.plugin.zsh" ]; then
    source "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.plugin.zsh"
  elif [ -f "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh" ]; then
    source "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh"
  elif [ -f "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh-theme" ]; then
    source "$HOME/.config/repos/$ORG/$PLUGIN/$PLUGIN.zsh-theme"
   fi
}

# If the llvm package is installed with brew, then setup the correct environment variables.
function brew-llvm() {
  if brew list | grep paco >/dev/null; then
    # To use the bundled libc++ please add the following LDFLAGS:
    # export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++"

    # llvm is keg-only, which means it was not symlinked into /opt/homebrew,
    # because macOS already provides this software and installing another version in
    # parallel can cause all kinds of trouble.

    # If you need to have llvm first in your PATH, run:
    echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc

    # For compilers to find llvm you may need to set:
    export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
  fi
}

# Enable completions inside the session
function enable-completions() {

  if which kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
  fi

  # aws cli completions
  if which aws >/dev/null 2>&1; then
    complete -C '/usr/local/bin/aws_completer' aws
  fi

  if which bun >/dev/null 2>&1; then
    source "/Users/guzmanmonne/.bun/_bun"
  fi

  # The next line enables shell command completion for gcloud.
  if [ -f "${HOME}/.local/google-cloud-sdk/completion.zsh.inc" ]; then source "${HOME}/.local/google-cloud-sdk/completion.zsh.inc"; fi

  autoload bashcompinit && bashcompinit
  autoload -Uz compinit && compinit
}

function load-pyenv() {
  # Source the virtualenvwrapper if it exists.
  if [ -f "/opt/homebrew/bin/virtualenvwrapper.sh" ]; then
    # Setup virtualenv home.
    echo export WORKON_HOME=$HOME/.virtualenvs

    # Tell pyenv-virtualenvwrapper to use pyenv when creating new Python environments.
    echo export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

    # PyEnv configuration
    echo export PYENV_VIRTUALENV_DISABLE_PROMPT=1

    # Set the pyenv shims to initialize
    if command -v pyenv 1>/dev/null 2>&1; then
      pyenv init -
    fi

    cat /opt/homebrew/bin/virtualenvwrapper.sh
  fi
}

# Configures the correct version of node using nvm
function load-nvmrc() {
  zsh_add_plugin "lukechilds/zsh-nvm"

  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

function quill() {
  gum write --width 81 --height 10 --header "Chat" --placeholder "Write your prompt here..." --show-cursor-line --char-limit 0 "$@"
}
