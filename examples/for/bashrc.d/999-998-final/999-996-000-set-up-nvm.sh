NVM_DIR=".nvm"
export NVM_DIR="$(
	[ -v XDG_CONFIG_HOME ] && echo "${XDG_CONFIG_HOME}/$NVM_DIR" || echo "${HOME}/$NVM_DIR"
)"

for script in nvm.sh bash_completion; do
	script="$NVM_DIR/$script"
	[ -s "$script" ] && source "$script"
done

unset script
