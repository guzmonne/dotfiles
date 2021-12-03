# Personal

On this folder I can find all my personal configuration files and scripts.

## Dependencies

- `zsh`
- `OhMyZsh`
- `nvim`
- `stow`
- `Powerlevel10k`

## Dependencies

One of my key dependencies is NodeJS. I like using [`n`](https://github.com/tj/n) to handle NodeJS
installations, but don't like to install a first version of `npm` to be able to install `n`. Instead,
I prefer to clone the `n` repository and then build it locally providing the `PREFIX` envionment
variable. The `PREFIX` environment variable tells `n` where it should install the binaries and all
versions of NodeJS. If you choose `n` to reside in a folder managed by your user you'll avoid a bunch
of potential permission bugs.

```sh
# Clone `n` repository
git clone https://github.com/tj/n.git /tmp/n

# Build n
cd /tmp/n
PREFIX=/Users/gmonne/.local/n make install

# Clean up
cd -
rm -Rf /tmp/n
```

## Getting Started

Clone the repository.

Stow the files in the repository to the appropriate folders.

> You might have to create the `~/.config` folder first: `mkdir ~/.config`.

```bash
# Stow the repos folder
stow -t ~/.config repos

# Stow the .config folder
stow -t ~/.config .config

# Stow the .zshrc config
stow -t ~ ./zshrc

# Stow the scripts folder
stow -t ~/bin ./scripts
```

After stowing the files you need to install `nvim` plugins.

```bash
:PlugInstall
```

Reset `nvim` to see the new plugins in action.

## Better Touch Tool

The best tool I could find to create global keyboard shortcuts is
"BetterTouchTool". You can install this app through SetApp, or
look it online.

### `popup-app`

> This script requires `Alacritty` to be installed.

The `popup-app` script opens a new `Alacritty` terminal running `fzf`
over folders where macOS `app` files can be found. You can then
fuzzy-find your way to the app you want to open. It works similar to
how `Spotlight` or `Alfred` works. Only 100% faster and simpler.

I set this script to be run when I press <Alt-Shift-P> using
`BetterTouchTool`.

> A script called `popup.sh` is available to call Alacritty with any
> command.
