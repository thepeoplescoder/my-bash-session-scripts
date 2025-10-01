#
# ~/.bash_aliases
#

# Keep track of where we are
FILE_THAT_SOURCED_BASH_ALIASES=$THIS_FILE_NAME
THIS_FILE_NAME='.bash_aliases'

# Let user know we're in here
__add_label_if_logged_in_as__ root
__say_that_we_are__ "Entering" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

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
__add_label_if_logged_in_as__ root
__say_that_we_are__ "Leaving" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

# Restore the name to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASH_ALIASES

