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

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/.local/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/.local/google-cloud-sdk/path.zsh.inc"; fi

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

# Reset the ohmyposh .env file
rm -Rf ~/.config/ohmyposh/.env
