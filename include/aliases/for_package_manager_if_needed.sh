source "$__MY_INCLUDE_DIR__/libraries/helper_functions.sh"

if command_exists 'pacman'; then
	alias pacman='pacman --color=auto '
fi

if command_exists 'paru'; then
	alias paru='paru --color=auto '
fi
