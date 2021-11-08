# Personal

On this folder I can find all my personal configuration files and scripts.

## Dependencies

- `zsh` 
- `OhMyZsh`
- `nvim`
- `stow`
- `Powerlevel10k`

## Getting Started

Clone the repository.

Stow the files in the repository to the appropriate folders.

> You might have to create the `~/.config` folder first: `mkdir ~/.config`.

```bash
# Stow the repos folder
stow -t ~/.config repos

# Stow the .config folder
stow -t ~/.config .config

#  Stow the .zshrc config
stow -t ~ ./zshrc
```

After stowing the files you need to install `nvim` plugins.

```bash
:PlugInstall
```

Reset `nvim` to see the new plugins in action.

## Update configuration

### `.zshrc`

You have to change the path of the `OhMyZsh` repository if your name is not `gmonne`.

```bash
# Path to your oh-my-zsh installation.
export ZSH="/Users/gmonne/.oh-my-zsh"
```

