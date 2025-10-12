unset_on_exit DIRCOLORS_FILE
DIRCOLORS_FILE="$HOME/.dircolors"

if [[ ! -f "$DIRCOLORS_FILE" ]]; then
	dircolors --print-database > "$DIRCOLORS_FILE"
fi

eval "$(dircolors "$DIRCOLORS_FILE")"
