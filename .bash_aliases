#
# ~/.bash_aliases
#

# Keep track of where we are
FILE_THAT_SOURCED_BASH_ALIASES=$THIS_FILE_NAME
THIS_FILE_NAME='.bash_aliases'

# Let user know we're in here
__bash_sessionstart_notify__ "Entering"; echo

# Some useful aliases, and others for color
alias ls='LC_COLLATE=C ls --group-directories-first --color=auto'
alias grep='grep --color=auto'
alias sudo='sudo '
alias ip='ip -color=auto'
alias diff='diff --color=auto'
alias mvv='mv -v'
alias cpv='cp -v'
alias cd..='cd ..'

if command_exists 'pacman'; then
	alias pacman='pacman --color=auto '
elif command_exists 'apt'; then
	echo "Found apt."
	alias apt-get='apt'
	if ! command_exists 'nala'; then
		echo "Consider installing nala!"
	fi
fi

# Let user know we're leaving
__bash_sessionstart_notify__ "Leaving"; echo

# Restore the name to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASH_ALIASES
