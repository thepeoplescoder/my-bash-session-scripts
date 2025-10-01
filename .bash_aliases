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
alias pacman='pacman --color=auto'
alias diff='diff --color=auto'
alias mvv='mv -v'
alias cpv='cp -v'
alias cd..='cd ..'

# Disable rustup for root user
if is-root-user; then
	alias rustup='echo "Please run this command from user $(id -nu 1000)."'
fi

# Let user know we're leaving
__bash_sessionstart_notify__ "Leaving"; echo

# Restore the name to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASH_ALIASES

