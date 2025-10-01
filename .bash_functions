#
# ~/.bash_functions
#

# Keep track of where we are
FILE_THAT_SOURCED_BASH_FUNCTIONS=$THIS_FILE_NAME
THIS_FILE_NAME='.bash_functions'

# Let user know we're in here
# __add_label_if_logged_in_as__ root
# __say_that_we_are__ "Entering" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
# echo
__bash_sessionstart_notify__ "Entering"; echo

# Let user know we're leaving
# __add_label_if_logged_in_as__ root
# __say_that_we_are__ "Leaving" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
# echo
__bash_sessionstart_notify__ "Leaving"; echo

# Restore the name to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASH_FUNCTIONS
