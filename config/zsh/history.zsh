# Avoid storing commands starting with a space on the history.
export HISTCONTROL=ignoreboth

# History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 20000 ] && SAVEHIST=20000

# History command configuration
setopt extended_history       # Record timestamp of command in HISTFILE.
setopt hist_ignore_all_dups   # Remove older duplicates entries from history.
setopt hist_reduce_blanks     # Remove superfluous blanks from history items.
setopt inc_append_history     # Save history entries as sson as they are entered.
setopt hist_expire_dups_first # Delete duplicates first when HISTFILE size exceeds HISTSIZE.
setopt hist_ignore_dups       # Ignore duplicated commands in history list.
setopt hist_ignore_space      # Ignore commands that start with a space.
setopt hist_verify            # Show commands with history expansion to user before running it.
setopt share_history          # Share command history data.

