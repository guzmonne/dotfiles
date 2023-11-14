# Personal

On this folder I can find all my personal configuration files and scripts.

- [Getting Started](#getting-started)
  - [Clone repository](#clone-repository)
  - [Install Dependencies [1/2]](#install-dependencies-[1/2])
  - [Stowing configuration files](#stowing-configuration-files)
  - [Decrypt secrets](#decrypt-secrets)
  - [Install Dependencies [2/2]](#install-dependencies-[2/2])
  - [Font Configuration](#font-configuration)
  - [Kitty Configuration](#kitty-configuration)
  - [Nvim Configuration](#nvim-configuration)
- [Tinker Tool](#tinker-tool)
- [Yabai and Skhd](#yabai-and-skhd)

## Getting Started

### Clone repository

These are the recommended steps to install everything from scratch on a new machine. First, start by
installing `brew`. You should check their [site](https://brew.sh/) to get the current installation
method. Then install GitHub's cli tool using `brew`.

```bash
brew install gh
```

We are going to need to create a new `ssh` key to access this repository:

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

You should now have a public and a private key on `$HOME/.ssh`. Make a note of its location.

Log in to your account using `gh auth login`, and add the `ssh` key we created previously.

We can now clone this repository. Create a directory called `$HOME/Projects/Personal` and clone
this repository there.

```bash
mkdir -p ~/Projects/Personal
gh clone guzmonne/dotfiles ~/Projects/Personal
```

### Install Dependencies [1/2]

We need to install all dependencies in two steps. First, we'll install all dependencies that require
`brew`, `luarocks` and `git`. This will allow us to load the `zsh` configuration so we can continue
installing the other dependencies.

```bash
ansible-playbook "$HOME/Projects/Personal/ansible/brew.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/clone.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/luarocks.yml" --extra-vars="root=$HOME/Projects/Personal"
```

> It's very important that you provide the `root` variable as an `extra-var`.

### Stowing configuration files

The next step requires `stowing` our configuration files into their appropriate folders. Most of them
will go inside the `~/.config` and `~/.local/bin` folders so start by creating them.

```bash
# Create the required directories
mkdir -p ~/.config
mkdir -p ~/.config/repos
mkdir -p ~/.local/bin

# Stow the repos folder
stow -t ~/.config/repos repos

# Stow the .config folder
stow -t ~/.config config

# Stow the dotfiles
mv ~/.zprofile ~/.zprofile.bak
mv ~/.zshrc ~/.zshrc.bak
stow -t ~ dotfiles

# Create symlinks
ansible-playbook "$HOME/Projects/Personal/ansible/symlinks.yml" --extra-vars="root=$HOME/Projects/Personal"

# Stow the scripts folder
stow -t ~/.local/bin scripts
```

### Decrypt secrets

This project includes secret files encoded using [`transcrypt`](https://github.com/elasticdog/transcrypt).
We need to decode them before we can continue with the next steps. The key to unencrypt them is stored
in 1Password.

```bash
./repos/elasticdog/transcrypt/transcrypt -c aes-256-cbc -p '<1Password secrets password>'
```

Now we can `stow` the secrets.

```bash
# Stow ssh keys
stow -t ~/.ssh -d secrets ssh
```

### Install Dependencies [2/2]

We can continue installing additional dependencies. First, let's install `nodejs`, `rust`, and `go`.

**NodeJS:**

```bash
source ~/.config/repos/lukechilds/zsh-nvm/zsh-nvm.plugin.zsh
nvm install 16 --default
nvm install 18
```

**Go:**

Follow the instructions [here](https://go.dev/doc/install). Then add `/usr/local/go/bin` to the path.

```bash
export PATH=/usr/local/go/bin:$PATH
```

**Rust:**

Follow the instructions [here](https://www.rust-lang.org/tools/install). Then run:

```bash
export PATH=$HOME/.cargo/bin:$PATH
source "$HOME/.cargo/env"
```

And run additional tasks.

```bash
ansible-playbook "$HOME/Projects/Personal/ansible/npm.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/go.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/cargo.yml" --extra-vars="root=$HOME/Projects/Personal"
ansible-playbook "$HOME/Projects/Personal/ansible/tasks.yml" --extra-vars="root=$HOME/Projects/Personal"
```

At this point you should be able to open a new `zsh` session with no errors and fully configured.

### Font Configuration

I use [`CartographCF`](https://connary.com/cartograph.html) as my main terminal font. Unfortunately,
it doesn't come with a NERDFont variant, so I had to create my own. I won't provide a link to it
given that its not a free font.

You can buy it and follow the steps here to create your own:

[https://github.com/ryanoasis/nerd-fonts#option-9-patch-your-own-font](https://github.com/ryanoasis/nerd-fonts#option-9-patch-your-own-font)

### Kitty Configuration

Once `zsh` is configured with all the other `dotfiles` and you've finished installing the `dependencies`
and your fonts, you can restart `kitty` to see the new configuration taking effect.

### Nvim Configuration

The first time you open `nvim` it will show a bunch of errors. This is because we need to install
all the plugins. Open `nvim` and run `:PlugInstall` to install them. Once it finishes restart
`nvim`. Everything should work as expected after the restart.

Reset `nvim` to see the new plugins in action.

## Tinker Tool

Consider using [Tinker Tool](http://www.bresink.com/osx/TinkerToolOverview.html) to change the
behavior of the finder and dock application.

## Yabai and Skhd

Lastly, install [`yabai`](https://github.com/koekeishiya/yabai) and
[`skhd`](https://github.com/koekeishiya/skhd) by following their respective guides.

## Pyenv

This is the best guide I could find to install `pyenv`.

[Setting up your python development environment (with pyenv, virtualenv, and virtualenvwrapper)](https://gist.github.com/wronk/a902185f5f8ed018263d828e1027009b)

### Workflow

Once installed, you can manage:

- Python versions with `pyenv`.
- Create new virtual environments with `mkvirtualenv`.
- Change between virtual environments through `workon`.

**Example:**

```bash
pyenv global 3.6.3           # Set your system's Python version with pyenv
mkvirtualenv my_legacy_proj  # Create a new virtual environment using virtualenvwrapper; it'll be tied to Python 3.6.3
pip install numpy scipy      # Install the packages you want in this environment

pyenv global 3.8.2         # Set your system's Python version with pyenv
mkvirtualenv new_web_proj  # Create and switch to a new virtual environment with a newer version of python
pip install flask boto

workon                 # List the environments available
workon my_legacy_proj  # Use virtualenvwrapper to switch back to the original Projects
```
