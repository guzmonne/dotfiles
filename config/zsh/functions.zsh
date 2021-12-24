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
