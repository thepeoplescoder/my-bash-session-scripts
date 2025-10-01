#
# ~/.bash_profile
#

# This is also used by .bashrc
INITIAL_LOCAL_VARIABLES_FILENAME=".bash_initial_local_variables"
INITIAL_LOCAL_VARIABLES_DIR=$HOME
INITIAL_LOCAL_VARIABLES_PATH="$INITIAL_LOCAL_VARIABLES_DIR/$INITIAL_LOCAL_VARIABLES_FILENAME"

# Load our initial local variables if they exist
if [[ -f "$INITIAL_LOCAL_VARIABLES_PATH" ]]; then
    __add_label_if_logged_in_as__ root
    __say_that_we_are__ "Loading" "initial local variables" "" ""
    echo
    source $INITIAL_LOCAL_VARIABLES_PATH
    BASH_LOCAL_VARIABLES_LOADED="yes"
fi

# Keep track of where we are
FILE_THAT_SOURCED_BASH_PROFILE=$THIS_FILE_NAME
THIS_FILE_NAME='.bash_profile'

# Let user know we're in here
__add_label_if_logged_in_as__ root
__say_that_we_are__ "Running the rest of" "$THIS_FILE_NAME" \
                    "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
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
