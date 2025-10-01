#
# ~/.bash_profile
#

# ANSI escape sequences
FCOLOR_BRIGHT_BLUE=$(tput setaf 12)
FCOLOR_BRIGHT_CYAN=$(tput setaf 14)
FCOLOR_BRIGHT_WHITE=$(tput setaf 15)
FCOLOR_YELLOW=$(tput setaf 226)
FCOLOR_RED=$(tput setaf 1)
FCOLOR_BRIGHT_RED=$(tput setaf 9)
FCOLOR_ORANGE=$(tput setaf 208)
RESET_TERMINAL=$(tput sgr0)

# Keep track of where we are
FILE_THAT_SOURCED_BASH_PROFILE=$THIS_FILE_NAME
THIS_FILE_NAME='.bash_profile'

# Let user know we're in here
__add_label_if_logged_in_as__ root
__say_that_we_are__ "Entering" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

# Load user's ~/.bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Let user know we're leaving
__add_label_if_logged_in_as__ root
__say_that_we_are__ "Leaving" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

# Restore the name to the script that sourced this one
# (should be nothing in this case)
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASH_PROFILE
