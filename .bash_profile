#
# ~/.bash_profile
#

# !BEGIN_SECTION cleanup
__cleanup_VARIABLES_TO_UNSET=()
function unset_on_exit() {
	local name
	for name in "$@"; do
		__cleanup_VARIABLES_TO_UNSET+=("$name")
	done
}

function __call_this_at_the_very_end__() {
	for name in "${__cleanup_VARIABLES_TO_UNSET[@]}"; do
		unset -f "$name" 2>/dev/null
		unset    "$name" 2>/dev/null
	done
	__cleanup_VARIABLES_TO_UNSET=()
	unset __cleanup_VARIABLES_TO_UNSET
	echo
}

unset_on_exit unset_on_exit
unset_on_exit __call_this_at_the_very_end__
# !END_SECTION cleanup

# !BEGIN_SECTION sourced-file-stack
# Create a stack to keep track of sourced files
if [ ! -v SOURCED_FILE_STACK ]; then
	unset_on_exit SOURCED_FILE_STACK
    declare -a SOURCED_FILE_STACK

	unset_on_exit __enter_this_file__
	function __enter_this_file__() {
		thisFileName="${BASH_SOURCE[1]/#$HOME/\~}"
		SOURCED_FILE_STACK+=("$thisFileName")
	}

	unset_on_exit __leave_this_file__
	function __leave_this_file__() {
		sourcedFileStackSize=${#SOURCED_FILE_STACK[@]}
		if [ $sourcedFileStackSize -lt 1 ]; then
			return
		fi

		lastIndexOfStack=$(( $sourcedFileStackSize - 1 ))
		unset "SOURCED_FILE_STACK[lastIndexOfStack]"
	}

	unset_on_exit __this_file_name__
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
# !END_SECTION sourced-file-stack

__enter_this_file__

# !BEGIN_SECTION colors
if [ ! -v COLOR_STACK ]; then
	unset_on_exit COLOR_STACK
	declare -a COLOR_STACK

	unset_on_exit __color__
	function __color__() {
		if [[ "$1" == "bright" ]]; then
			echo -n "1;"
			shift
		fi

		case "$1" in
			black)
				echo 30
				;;
			red)
				echo 31
				;;
			green)
				echo 32
				;;
			yellow)
				echo 33
				;;
			blue)
				echo 34
				;;
			magenta)
				echo 35
				;;
			cyan)
				echo 36
				;;
			white)
				echo 37
				;;
			default)
				echo 39
				;;
			*)
				echo $1
				;;
		esac
	}

	unset_on_exit __ansi__
	function __ansi__() {
		local cmd=$1
		shift
		case "$cmd" in
			color)
				echo -ne "\e[$(__color__ $1)m"
				;;
			fg-256)
				__ansi__ color "38;5;$1"
				;;
			bg-256)
				__ansi__ color "48;5;$1"
				;;
			fg-rgb)
				__ansi__ color "38;2;$1;$2;$3"
				;;
			bg-rgb)
				__ansi__ color "48;2;$1;$2;$3"
				;;
			reset)
				__ansi__ color 0
				;;
			bright)
				__ansi__ color $(__color__ bright $1)
				;;
			*)
				__ansi__ reset
				;;
		esac
	}

	unset_on_exit __theme__
	function __theme__() {
		case "$1" in
			normal)
				__ansi__ bright blue
				;;
			highlight)
				__ansi__ bright yellow
				;;
		esac
	}

	__ansi__ reset

	unset_on_exit __set_color__
	function __set_color__() {
		if [[ "$1" == "" ]]; then
			__ansi__ reset
		else
			__ansi__ color $1
		fi
	}

	unset_on_exit set_color
	function set_color() {
		COLOR_STACK+=("$1")
		__set_color__ $1
	}

	unset_on_exit peek_color
	function peek_color() {
		local colorStackSize=${#COLOR_STACK[@]}
		if [ $colorStackSize -lt 1 ]; then
			echo ""
		else
			local lastIndex=$(( $colorStackSize - 1 ))
			echo "${COLOR_STACK[lastIndex]}"
		fi
	}

	unset_on_exit pop_color
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

	export -f __color__
	export -f __ansi__
	export -f __theme__
fi
# !END_SECTION colors

# !BEGIN_SECTION indented-echo
unset_on_exit __iecho_INDENT __iecho_INDENT_STRING
__iecho_INDENT=0
__iecho_INDENT_STRING="   "

unset_on_exit _indent
function _indent() {
	local i
	for (( i=0; i<__iecho_INDENT; i++ )); do
		echo -n "$__iecho_INDENT_STRING"
	done
}
export -f _indent

unset_on_exit iecho
function iecho() {
	_indent; echo "$@"
}
export -f iecho

unset_on_exit _push_indent
function _push_indent() {
	__iecho_INDENT=$(( __iecho_INDENT + 1 ))
}

unset_on_exit _pop_indent
function _pop_indent() {
	__iecho_INDENT=$(( __iecho_INDENT - 1 ))
	[[ $__iecho_INDENT -lt 0 ]] && __iecho_INDENT=0
}
# !END_SECTION indented-echo

# !BEGIN_SECTION BASH_SESSION_SCRIPTS_HOME
BASH_SESSION_SCRIPTS_HOME_FILE="$HOME/.bash_session_scripts_home"
if [[ -f "$BASH_SESSION_SCRIPTS_HOME_FILE" ]]; then
    BASH_SESSION_SCRIPTS_HOME=$(cat "$BASH_SESSION_SCRIPTS_HOME_FILE")
else
    iecho -n "Error: $(set_color $FG_DEFAULT)$BASH_SESSION_SCRIPTS_HOME_FILE$(pop_color) "
	echo     "not found."
    return
fi
unset_on_exit BASH_SESSION_SCRIPTS_HOME_FILE
# !END_SECTION BASH_SESSION_SCRIPTS_HOME

# !BEGIN_SECTION BASH_SESSION_SCRIPTS_HOME-directory-check
# Print a single line of text in a box.
unset_on_exit box_print box_horizontal_line
function box_print() {
	msg="| $1 |"
	numDashes=${#msg}
	numDashes=$((numDashes - 2))

	box_horizontal_line $numDashes
	iecho "$msg"
	box_horizontal_line $numDashes
}
function box_horizontal_line() {
	iecho -n '+'
	printf '%.0s-' $(seq 1 $1)
	echo '+'
}

# Leave if BASH_SESSION_SCRIPTS_HOME does not point to a directory.
# The comments surrounding the following if block are required for
# .bashrc to read this code when it needs it.
if [[ ! -d "$BASH_SESSION_SCRIPTS_HOME" ]]; then
	set_color $FG_DEFAULT
	set_color $FG_DEFAULT
	echo
	box_print "Error in $(__this_file_name__)"
	echo
	pop_color

	set_color $FG_DEFAULT
	iecho -n "BASH_SESSION_SCRIPTS_HOME "
	pop_color
	echo "must point to the installation directory."
	echo

	set_color $FG_DEFAULT
	iecho -n "To fix this"
	pop_color
	echo ", go to the installation directory where your session scripts are"
	echo "located and run:"
	echo

	set_color $FG_DEFAULT
	_push_indent
	iecho "pwd > ~/$(basename "$BASH_SESSION_SCRIPTS_HOME_FILE")"
	_pop_indent
	pop_color
	pop_color
	echo

	return
fi
# !END_SECTION BASH_SESSION_SCRIPTS_HOME-directory-check

# !BEGIN_SECTION initial-local-variables
# This is also used by .bashrc via grep
INITIAL_LOCAL_VARIABLES_FILENAME="initial_local_variables"
INITIAL_LOCAL_VARIABLES_PATH="$BASH_SESSION_SCRIPTS_HOME/$INITIAL_LOCAL_VARIABLES_FILENAME"

# Load our initial local variables if they exist
if [[ -f "$INITIAL_LOCAL_VARIABLES_PATH" ]]; then
    __add_username_label_if_logged_in_as__ root
    __say_that_we_are__ "Loading initial local variables from" "$(__this_file_name__)"
    echo
    source $INITIAL_LOCAL_VARIABLES_PATH
else
	iecho "Error occurred while running $(__this_file_name__):"
	echo
	iecho "\$INITIAL_LOCAL_VARIABLES_PATH not declared in $dataSource."
	echo
	iecho "Please put this declaration in $dataSource, pointing to the"
	iecho "location of the file containing the initial local variable declarations."
	echo
	return
fi
# !END_SECTION initial-local-variables

# Let user know we're in here
__add_username_label_if_logged_in_as__ root
__say_that_we_are__ "Running the rest of" "$(__this_file_name__)"
echo

# Load user's ~/.bashrc if it exists
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Let user know we're leaving
__add_username_label_if_logged_in_as__ root
__say_that_we_are__ "Leaving" "$(__this_file_name__)"
echo

__leave_this_file__
__call_this_at_the_very_end__