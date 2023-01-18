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

# Configures the correct version of node using nvm
function load-nvmrc() {
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

