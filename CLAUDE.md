# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files, scripts, custom Neovim plugins, and automation tools for a macOS development environment.

## Key Architecture

### Directory Structure

- **`config/`** - All configuration files (nvim, zsh, tmux, etc.)
- **`scripts/`** - Personal utility scripts and automation tools
- **`plugins/`** - Custom Neovim plugins developed locally
- **`ansible/`** - Ansible playbooks for system setup and dependency management
- **`dotfiles/`** - Files that get stowed to the home directory
- **`secrets/`** - Encrypted files managed by transcrypt
- **`repos/`** - Third-party repositories cloned locally

### Neovim Configuration

The Neovim setup uses LazyVim as the base configuration:

- **Base**: LazyVim framework with lazy.nvim plugin manager
- **Config location**: `config/nvim/`
- **Custom plugins**: Located in `plugins/` directory and loaded via dev configuration
- **Plugin patterns**: Custom plugins follow the pattern `{ "cloudbridge" }` for local development
- **Key files**:
  - `config/nvim/init.lua` - Entry point
  - `config/nvim/lua/config/lazy.lua` - Plugin manager setup
  - `config/nvim/lua/plugins/` - Plugin configuration files

### Custom Neovim Plugins

Several custom plugins are developed in the `plugins/` directory:

- **`tmuxrepl/`** - TMUX REPL integration
- **`present/`** - Presentation mode for Neovim
- **`llm-stream/`** - LLM streaming integration
- **`freeze/`** - Code screenshot generation
- **`manim/`** - Manim animation integration
- **`mods/`** - AI-powered CLI tool integration
- **`twohtml/`** - HTML export functionality

### Scripts and Automation

The `scripts/` directory contains numerous utility scripts for:

- AI/LLM integrations (anthropic.sh, ollama.sh, replicate.sh)
- AWS and cloud tools (aws.sh, kubectl-* scripts)
- Development utilities (git.sh, gh.sh, tmux-*.sh)
- macOS system management (yabai.sh, osx.sh)

## Common Development Commands

### System Setup
```bash
# Full system setup (run these in order)
ansible-playbook "$HOME/Projects/Personal/ansible/brew.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/clone.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/luarocks.yml" --extra-vars="root=$HOME/Projects/Personal"

# Stow configuration files
stow -t ~/.config config
stow -t ~ dotfiles
stow -t ~/.local/bin scripts

# Install additional dependencies
ansible-playbook "$HOME/Projects/Personal/ansible/npm.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/go.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/cargo.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/tasks.yml" --extra-vars="root=$HOME/Projects/Personal"
```

### Neovim Plugin Development
```bash
# Plugins are loaded from ~/Projects/Personal/plugins/ automatically
# No build commands needed - plugins are loaded directly by LazyVim
```

### Scripts Development
```bash
# Scripts are written in bash/shell and executed directly
# No build process required
# Located in scripts/ directory and stowed to ~/.local/bin
```

## Secret Management

- Uses `transcrypt` for encrypting sensitive files
- Secrets are stored in the `secrets/` directory
- Decrypt with: `./repos/elasticdog/transcrypt/transcrypt -c aes-256-cbc -p '<password>'`
- SSH keys, API tokens, and other sensitive data are managed this way

## Font and Terminal Setup

- Primary font: CartographCF (commercial font, requires separate purchase)
- Terminal: Kitty with custom configuration
- Color scheme: Tokyo Night theme used throughout
- Window manager: Yabai + SKHD for macOS tiling

## Development Workflow

1. Configuration changes are made in the `config/` directory
2. Scripts are developed in `scripts/` directory
3. Custom Neovim plugins are developed in `plugins/` directory
4. Use `stow` commands to symlink configurations to appropriate locations
5. Ansible playbooks handle dependency management and system setup
6. All changes are version controlled with git