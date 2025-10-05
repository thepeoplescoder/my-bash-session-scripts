#
# ~/.bash_profile
#

# BASH_PROFILE_createStack_start
# Create a stack to keep track of sourced files
if [ ! -v SOURCED_FILE_STACK ]; then
    declare -a SOURCED_FILE_STACK

	function __enter_this_file__() {
		thisFileName="${BASH_SOURCE[1]}"
		if [[ "$(basename "$thisFileName")" == .* ]]; then
			thisFileName="$(basename "$thisFileName")"
		fi
		SOURCED_FILE_STACK+=("$thisFileName")
	}

	function __leave_this_file__() {
		sourcedFileStackSize=${#SOURCED_FILE_STACK[@]}
		if [ $sourcedFileStackSize -lt 1 ]; then
			return
		fi

		lastIndexOfStack=$(( $sourcedFileStackSize - 1 ))
		unset "SOURCED_FILE_STACK[lastIndexOfStack]"
	}

	function __this_file_name__() {
		sourcedFileStackSize=${#SOURCED_FILE_STACK[@]}
		if [ $sourcedFileStackSize -lt 1 ]; then
			echo "<empty>"
		else
			lastIndexOfStack=$(( $sourcedFileStackSize - 1 ))
			echo "${SOURCED_FILE_STACK[lastIndexOfStack]}"
		fi
	}
fi
# BASH_PROFILE_createStack_end

# BASH_PROFILE_colorStack_start
if [ ! -v COLOR_STACK ]; then
	declare -a COLOR_STACK
	tput sgr0

	function __set_color__() {
		if [[ "$1" == "" ]]; then
			tput sgr0
		else
			tput setaf $1
		fi
	}

	function set_color() {
		COLOR_STACK+=("$1")
		__set_color__ $1
	}

	function peek_color() {
		local colorStackSize=${#COLOR_STACK[@]}
		if [ $colorStackSize -lt 1 ]; then
			echo ""
		else
			local lastIndex=$(( $colorStackSize - 1 ))
			echo "${COLOR_STACK[lastIndex]}"
		fi
	}

	function pop_color() {
		local colorStackSize=${#COLOR_STACK[@]}
		if [ $colorStackSize -lt 1 ]; then
			__set_color__
		else
			local lastIndex=$(( $colorStackSize - 1 ))
			unset "COLOR_STACK[lastIndex]"
			__set_color__ $(peek_color)
		fi
	}
fi
# BASH_PROFILE_colorStack_end

__enter_this_file__

# This file contains the directory where all of our scripts are.
# .bashrc also uses this line to get this information.
BASH_SESSION_SCRIPTS_HOME_FILE="$HOME/.bash_session_scripts_home"

# Initialzie BASH_SESSION_SCRIPTS_HOME
if [[ -f "$BASH_SESSION_SCRIPTS_HOME_FILE" ]]; then
    BASH_SESSION_SCRIPTS_HOME=$(cat "$BASH_SESSION_SCRIPTS_HOME_FILE")
else
    # echo "Error: $(tput setaf 14)$BASH_SESSION_SCRIPTS_HOME_FILE$(tput sgr0) not found."
    echo "Error: $(set_color 14)$BASH_SESSION_SCRIPTS_HOME_FILE$(pop_color) not found."
    return
fi

# BASH_SESSION_SCRIPTS_HOME_directoryCheck_start

# Print a single line of text in a box.
function box_print() {
	msg="| $1 |"
	numDashes=${#msg}
	numDashes=$((numDashes - 2))

	box_horizontal_line $numDashes
	echo "$msg"
	box_horizontal_line $numDashes
}
function box_horizontal_line() {
	echo -n '+'
	printf '%.0s-' $(seq 1 $1)
	echo '+'
}

# Leave if BASH_SESSION_SCRIPTS_HOME does not point to a directory.
# The comments surrounding the following if block are required for
# .bashrc to read this code when it needs it.
if [[ ! -d "$BASH_SESSION_SCRIPTS_HOME" ]]; then
	set_color 209
	set_color 9
	echo
	box_print "Error in $(__this_file_name__)"
	echo
	pop_color

	set_color 12
	echo -n "BASH_SESSION_SCRIPTS_HOME "
	pop_color
	echo "must point to the installation directory."
	echo

	set_color 226
	echo -n "To fix this"
	pop_color
	echo ", go to the installation directory where your session scripts are"
	echo "located and run:"
	echo

	set_color 10
	echo "   pwd > ~/$(basename "$BASH_SESSION_SCRIPTS_HOME_FILE")"
	pop_color
	pop_color
	echo

	return
fi
# BASH_SESSION_SCRIPTS_HOME_directoryCheck_end

# This is also used by .bashrc via grep
INITIAL_LOCAL_VARIABLES_FILENAME="initial_local_variables"
INITIAL_LOCAL_VARIABLES_PATH="$BASH_SESSION_SCRIPTS_HOME/$INITIAL_LOCAL_VARIABLES_FILENAME"

# Load our initial local variables if they exist
if [[ -f "$INITIAL_LOCAL_VARIABLES_PATH" ]]; then
    __add_username_label_if_logged_in_as__ root
    __say_that_we_are__ "Loading initial local variables from" "$(__this_file_name__)" \
                        "" ""
    echo
    source $INITIAL_LOCAL_VARIABLES_PATH
fi

# Let user know we're in here
__add_username_label_if_logged_in_as__ root
__say_that_we_are__ "Running the rest of" "$(__this_file_name__)" \
                    "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

# Load user's ~/.bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Let user know we're leaving
__add_username_label_if_logged_in_as__ root
__say_that_we_are__ "Leaving" "$(__this_file_name__)" \
                    "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

# Blank line to keep things somewhat pretty
echo

__leave_this_file__