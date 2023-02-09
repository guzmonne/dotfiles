# Auto-load the load-nvmrc hook.
autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Autho-load Rust
if [[ -n "$HOME/.cargo/env" ]]; then
	source $HOME/.cargo/env
fi
