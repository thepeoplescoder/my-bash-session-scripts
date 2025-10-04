#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Keep track of where we are
FILE_THAT_SOURCED_BASHRC=$THIS_FILE_NAME
THIS_FILE_NAME='.bashrc'

# Add user's ~/bin to PATH if it exists
USERS_BIN="$HOME/bin"
[[ -d "$USERS_BIN" ]] && export PATH="$USERS_BIN:$PATH"

# To help clean things up.
function __bash_sessionstart_notify__() {
	if [[ "$2" == "" ]]; then
		x=$THIS_FILE_NAME
	else
		x=$2
	fi
    __add_username_label_if_logged_in_as__ root
	echo -n "$3"
    __say_that_we_are__ "$1" "$x" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
}

function __say__() {
	__add_username_label_if_logged_in_as__ root
	echo -n "$2"
	echo -n "$1"
}

function command_exists() {
	command -v "$@" &> /dev/null
}

# Displays an error message on a bad directory declaration
function __bad_directory_declaration__() {
	echo "In $THIS_FILE_NAME:"
	echo
	echo "   Invalid or no declaration for \$$1 in $INITIAL_LOCAL_VARIABLES_PATH"
	echo
	echo "   Please point this variable to a folder containing the location of your"
	echo "   $2 scripts."
	echo
}

# Get the location of the initial local variables if they haven't been loaded.
# This is defined in ~/.bash_profile in the lines looking like:
#
#     INITIAL_LOCAL_VARIABLES_something=value
#
if [[ "$BASH_LOCAL_VARIABLES_LOADED" == "" ]]; then

	# Load the variable declarations from ~/.bash_profile
	sourceFile=~/.bash_profile
	eval "$(grep -E '^INITIAL_LOCAL_VARIABLES_[[:alnum:]_]+=.*' $sourceFile)"

	# As a result, this variable must be declared, and must point to an actual file.
	if [[ ! -f "$INITIAL_LOCAL_VARIABLES_PATH" ]]; then
		echo "In $THIS_FILE_NAME:"
		echo
		echo "   \$INITIAL_LOCAL_VARIABLES_PATH not declared in $sourceFile."
		echo
		echo "   Please put this declaration in $sourceFile, pointing to the"
		echo "   location of the file containing the initial local variable declarations."
		echo
		return
	fi

	# Now we can load the variables.
	__bash_sessionstart_notify__ "Loading initial local variables from" "$THIS_FILE_NAME"; echo
	source $INITIAL_LOCAL_VARIABLES_PATH

	# Variables finally loaded.
	BASH_LOCAL_VARIABLES_LOADED="yes"
fi

# This variable must exist, and point to a directory.
if [[ ! -d "$BASH_SESSION_SCRIPTS_HOME" ]]; then
	__bad_directory_declaration__ "BASH_SESSION_SCRIPTS_HOME" "session"
	return
fi

# Scripts with conventional names: load them *first* if they exist.
for scriptName in "${CONVENTIONAL_SCRIPTS[@]}"; do
	shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
	if [[ -f "$shellScript" && -r "$shellScript" ]]; then
		source $shellScript
	fi
	unset shellScript
done

# Keep user posted on what we're doing
__bash_sessionstart_notify__ "Running the rest of"; echo

# Load any additional scripts if they exist
ADDITIONAL_SCRIPTS_LOCATION="$BASH_SESSION_SCRIPTS_HOME/$ADDITIONAL_SCRIPTS_DIRECTORY"
if [[ -d "$ADDITIONAL_SCRIPTS_LOCATION" ]]; then
	for shellScript in "$ADDITIONAL_SCRIPTS_LOCATION"/*; do
		if [[ -f "$shellScript" && -r "$shellScript" ]]; then
			__bash_sessionstart_notify__ "Loading" "$(basename $shellScript)" "   "
			source $shellScript
			echo " ${FCOLOR_BRIGHT_BLUE}done!${RESET_TERMINAL}"
		fi
	done
	unset shellScript
fi

# Load ending scripts
for scriptName in "${ENDING_SCRIPTS[@]}"; do
	shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
	if [[ -f "$shellScript" && -r "$shellScript" ]]; then
		source $shellScript
	fi
	unset shellScript
done

# Let user know we're leaving
__bash_sessionstart_notify__ "Leaving"; echo

# Restore the name of the current file to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASHRC
