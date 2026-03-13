export NVIM_DIR="$(
	[ ! "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm"
)"

script="$NVM_DIR/nvm.sh"
[ -s "$script" ] && source "$script"

script="$NVM_DIR/bash_completion"
[ -s "$script" ] && source "$script"

unset script
