#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Keep track of where we are
FILE_THAT_SOURCED_BASHRC=$THIS_FILE_NAME
THIS_FILE_NAME='.bashrc'

# To help clean things up.
function __bash_sessionstart_notify__() {
	if [[ "$2" == "" ]]; then
		x=$THIS_FILE_NAME
	else
		x=$2
	fi
    __add_label_if_logged_in_as__ root
	echo -n "$3"
    __say_that_we_are__ "$1" "$x" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
}

# Displays an error message on a bad directory declaration
function __bad_directory_declaration__() {
	echo "No declaration for \$$1 in"
	echo "$INITIAL_LOCAL_VARIABLES_PATH"
	echo
	echo "Please point this variable to a folder containing the location of your"
	echo "$2 scripts."
	echo
}

# Get the location of the initial local variables if they haven't been loaded.
# This is defined in ~/.bash_profile in the lines looking like:
#
#     INITIAL_LOCAL_VARIABLES_something=value
#
if [[ "$BASH_LOCAL_VARIABLES_LOADED" == "" ]]; then

	# Load the variable declarations from ~/.bash_profile
	eval "$(grep -E '^INITIAL_LOCAL_VARIABLES_[[:alnum:]_]+=.*' ~/.bash_profile)"

	# As a result, this variable must be decalred, and must point to an actual file.
	if [[ ! -f "$INITIAL_LOCAL_VARIABLES_PATH" ]]; then
		echo "\$INITIAL_LOCAL_VARIABLES_PATH not declared in \~/.bash_profile."
		echo
		echo "Please this declaration to your \~/.bash_profile, pointing to the"
		echo "location of the file containing initial local variable declarations."
		echo
		exit 1
	fi

	# Now we can load the variables.
	__bash_sessionstart_notify__ "Loading" "initial local variables"; echo
	source $INITIAL_LOCAL_VARIABLES_PATH

	# Variables finally loaded.
	BASH_LOCAL_VARIABLES_LOADED="yes"
fi

# This variable must exist.
if [[ ! -d "$BASH_SHELL_SCRIPTS_LOCATION" ]]; then
	__bad_directory_declaration__ "BASH_SHELL_SCRIPTS_LOCATION" "session"
	exit 1
fi

# This variable must exist.
if [[ ! -d "$ADDITIONAL_SCRIPTS_LOCATION" ]]; then
	__bad_directory_declaration__ "ADDITIONAL_SCRIPTS_LOCATION" "additional"
	exit 1
fi

# Scripts with conventional names: load them if they exist.
for scriptName in "${CONVENTIONAL_SCRIPTS[@]}"; do
	shellScript="$BASH_SHELL_SCRIPTS_LOCATION/$scriptName"
	if [[ -f "$shellScript" && -r "$shellScript" ]]; then
		source $shellScript
	fi
	unset shellScript
done

# Let user know we're in here
__bash_sessionstart_notify__ "Running the rest of"; echo

# Add user's ~/bin if it exists
[[ -d ~/bin ]] && export PATH="$HOME/bin:$PATH"

# Load any additional scripts if they exist
if [ -d "$ADDITIONAL_SCRIPTS_LOCATION" ]; then
	for shellScript in "$ADDITIONAL_SCRIPTS_LOCATION"/*; do
		if [[ -f "$shellScript" && -r "$shellScript" ]]; then
			__bash_sessionstart_notify__ "Loading" "$(basename $shellScript)" "   "
			source $shellScript
			echo " ${FCOLOR_BRIGHT_BLUE}done!${RESET_TERMINAL}"
		fi
	done
	unset shellScript
fi

# Set up PS1 prompt
if [[ -f "$BASH_SHELL_SCRIPTS_LOCATION/.bash_ps1" ]]; then
	source "$BASH_SHELL_SCRIPTS_LOCATION/.bash_ps1"
fi

# Let user know we're leaving
__bash_sessionstart_notify__ "Leaving"; echo

# Restore the name of the current file to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASHRC
