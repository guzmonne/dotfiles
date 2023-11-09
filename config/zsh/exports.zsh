#!/usr/bin/env bash

# Configure default ansible config file
export ANSIBLE_CONFIG=~/.ansible.cfg

# Color man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Use nvim to read Man pages
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# Add cargo binary directory to the path.
export PATH=$PATH:${HOME}/.cargo/bin

# Add a user binary directory to the path.
export PATH=$PATH:${HOME}/.local/bin

# Fix perl locale issue
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Fix OpenSSL link issue
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# Add Python 3.9 (default on MacOS) bin directory
if [ -d "${HOME}/Library/Python/3.9/bin" ]; then
  export PATH="${HOME}/Library/Python/3.9/bin:${PATH}"
fi

# Add conda install through homebrew to the path if it exists.
if [ -d "/opt/homebrew/anaconda3/bin" ]; then
  export PATH="/opt/homebrew/anaconda3/bin:${PATH}"
  conda init zsh 1>/dev/null
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/.local/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/.local/google-cloud-sdk/path.zsh.inc"; fi

# Make kubectl use the new gke_cloud_auth_plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/.local/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/.local/google-cloud-sdk/completion.zsh.inc"; fi

# Add gcloud to the global path
export PATH=$PATH:"${HOME}/.local/google-cloud-sdk/bin"

# Add n to the global path and configure N_PREFIX
export PATH=$PATH:"${HOME}/.local/n/bin"
export N_PREFIX="${HOME}/.local/n/versions"

# Configure Perl path
PATH="${HOME}/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LI:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"${HOME}/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"; export PERL_MM_OPT;

# Configure `fd` to work nicely with `fzf`.
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --exclude node_modules'
export FZF_DEFAULT_OPTS="--color=bg+:#292e42,spinner:#bb9af7,hl:#565f89,fg:#c0caf5,header:#565f89,info:#7dcfff,pointer:#bb9af7,marker:#7dcfff,fg+:#c0caf5,preview-bg:#1f2335,prompt:#bb9af7,hl+:#bb9af7"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Configure colors using `vivid`
export LS_COLORS="$(vivid generate tokyonight)"

# Configure nvim as the default editor
export EDITOR=nvim

# Add Go binary folder to the PATH
export PATH=$PATH:"$HOME/go/bin"
export GO111MODULE='on'

# Enable nvm autocompletions
export NVM_COMPLETION=true

## Colours and font styles
## Syntax: echo -e "${FOREGROUND_COLOUR}${BACKGROUND_COLOUR}${STYLE}Hello world!${RESET_ALL}"

# Escape sequence and resets
export ESC_SEQ="\x1b["
export RESET_ALL="${ESC_SEQ}0m"
export RESET_BOLD="${ESC_SEQ}21m"
export RESET_UL="${ESC_SEQ}24m"

# Foreground colours
export FG_BLACK="${ESC_SEQ}30;"
export FG_RED="${ESC_SEQ}31;"
export FG_GREEN="${ESC_SEQ}32;"
export FG_YELLOW="${ESC_SEQ}33;"
export FG_BLUE="${ESC_SEQ}34;"
export FG_MAGENTA="${ESC_SEQ}35;"
export FG_CYAN="${ESC_SEQ}36;"
export FG_WHITE="${ESC_SEQ}37;"
export FG_BR_BLACK="${ESC_SEQ}90;"
export FG_BR_RED="${ESC_SEQ}91;"
export FG_BR_GREEN="${ESC_SEQ}92;"
export FG_BR_YELLOW="${ESC_SEQ}93;"
export FG_BR_BLUE="${ESC_SEQ}94;"
export FG_BR_MAGENTA="${ESC_SEQ}95;"
export FG_BR_CYAN="${ESC_SEQ}96;"
export FG_BR_WHITE="${ESC_SEQ}97;"

# Background colours (optional)
export BG_BLACK="40;"
export BG_RED="41;"
export BG_GREEN="42;"
export BG_YELLOW="43;"
export BG_BLUE="44;"
export BG_MAGENTA="45;"
export BG_CYAN="46;"
export BG_WHITE="47;"

# Font styles
export FS_REG="21;24m"
export FS_BOLD="1m"
export FS_UL="4m"

# Add luarocks env variables
eval $(luarocks path)

# Configure the folder where all zsh configuration will live.
export ZDOTDIR=$HOME/.config/zsh

# Coursier export binaries path
export PATH="$PATH:/Users/gmonne/Library/Application Support/Coursier/bin"

# Configure the default folder for ZK notes.
export ZK_NOTEBOOK_DIR="$HOME/Notes"

# Configure BREW_TAP to install a fixed version of LibreSSL
export BREW_TAP='coral/local-dev-setup'

# Configure McFly
export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=2
export MCFLY_RESULTS=50
export MCFLY_INTERFACE_VIEW=BOTTOM
export MCFLY_DISABLE_MENU=TRUE

# Configure Bat
export BAT_THEME=ansi

# Add mysql@5.7 to the PATH if it has been installed through brew
local brew_prefix=$(brew --prefix)
if [ -d "$brew_prefix/opt/mysql@5.7" ]; then
  export PATH="$brew_prefix/opt/mysql@5.7/bin:$PATH"
  export LDFLAGS="$LDFLAGS -L$brew_prefix/opt/mysql@5.7/lib"
  export CPPFLAGS="$CPPFLAGS -I$brew_prefix/opt/mysql@5.7/include"
fi

# Allow GCP to get to external packages
export CLOUDSDK_PYTHON_SITEPACKAGES=1

# Source Secret Environment Variables
export $(cat "$HOME/Projects/Personal/secrets/cloudflare.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/openai.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/newrelic.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/anthropic.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/huggingface.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/c.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/github.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/replicate.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/gooseai.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/novelai.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/nlpcloud.env" | xargs)
export $(cat "$HOME/Projects/Personal/secrets/qdrant.env" | xargs)

# Source JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=$JAVA_HOME/bin:$PATH

# Configure the bash-language-server extension through the use of environment variables
export INCLUDE_ALL_WORKSPACE_SYMBOLS=true

# Configure Rust through environment variables
export CARGO_NET_GIT_FETCH_WITH_CLI=true

# Configure ~/.local/bin/kafka as part of the PATH
if [[ -d "$HOME/.local/kafka" ]]; then
  export PATH="$HOME/.local/kafka/bin:$PATH"
fi

# Configure ~ as part of the PATH
if [[ -d "/opt/homebrew/opt/gnu-getopt/bin" ]]; then
  export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
fi

# Configure the PATH to include the folder where the `bun` binary is installed
if [[ -d "$HOME/.bun/bin" ]]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Add the /opt/homebrew/opt/python@3.11/libexec/bin directory to the path if it exists.
if [ -d "/opt/homebrew/opt/python@3.11/libexec/bin" ]; then
  export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:${PATH}"
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
