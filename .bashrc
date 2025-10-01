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

# Get our initial local variables if they exist and haven't been loaded
if [[ "$BASH_LOCAL_VARIABLES_LOADED" == "" ]]; then
	if [[ -f ~/.bash_initial_local_variables ]]; then
		__bash_sessionstart_notify__ "Loading" "initial local variables"; echo
		source ~/.bash_initial_local_variables
	fi
fi

# Load these files if they exist
[[ -f ~/.bash_functions ]] && source ~/.bash_functions
[[ -f ~/.bash_aliases   ]] && source ~/.bash_aliases

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
PS1="${USERNAME_COLOR}\u${PS1_RESET_TERMINAL}${AT_COLOR}@${HOSTNAME_COLOR}\h${PS1_RESET_TERMINAL}"
PS1="${PS1} ${CURRENT_DIRECTORY_COLOR}\w"
PS1="${BRACKET_COLOR}[${PS1}${BRACKET_COLOR}]"
PS1="${PS1}${PROMPT_COLOR}${PROMPT_TERMINATOR}"
PS1="${PS1}${PS1_RESET_TERMINAL}"
if is-root-user; then
	PS1="${PS1}\\[\\]"
fi
PS1="${PS1} "

# Let user know we're leaving
__bash_sessionstart_notify__ "Leaving"; echo

# Restore the name of the current file to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASHRC
