#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
FILE_THAT_SOURCED_BASHRC=$THIS_FILE_NAME
THIS_FILE_NAME='.bashrc'

# Let user know we're in here
__add_label_if_logged_in_as__ root
__say_that_we_are__ "Entering" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

# Add user's ~/bin if it exists
[[ -d ~/bin ]] && export PATH="$HOME/bin:$PATH"

# Load these files if they exist
[[ -f ~/.bash_aliases   ]] && source ~/.bash_aliases
[[ -f ~/.bash_functions ]] && source ~/.bash_functions

# Location of additional scripts
BASH_SHELL_SCRIPTS_LOCATION="$HOME/.bash_shell_scripts"
ADDITIONAL_SCRIPTS_LOCATION="$BASH_SHELL_SCRIPTS_LOCATION/bashrc.d"

# Load any additional scripts if they exist
if [ -d "$ADDITIONAL_SCRIPTS_LOCATION" ]; then
	for shellScript in "$ADDITIONAL_SCRIPTS_LOCATION"/*; do
		if [[ -f "$shellScript" && -r "$shellScript" ]]; then
			__add_label_if_logged_in_as__ root
			echo -n "   "
			__say_that_we_are__ "Loading" "$(basename $shellScript)" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
			source $shellScript
			echo " ${FCOLOR_BRIGHT_BLUE}done!${RESET_TERMINAL}"
		fi
	done
	unset shellScript
fi

# PS1 prompt theme
BRACKET_COLOR="\\[$FCOLOR_RED\\]"
USERNAME_COLOR="\\[$FCOLOR_BRIGHT_RED\\]"
AT_COLOR="\\[$FCOLOR_ORANGE\\]"
HOSTNAME_COLOR=$USERNAME_COLOR
CURRENT_DIRECTORY_COLOR="\\[$FCOLOR_YELLOW\\]"
PROMPT_COLOR=$BRACKET_COLOR
PS1_RESET_TERMINAL="\\[$RESET_TERMINAL\\]"
PROMPT_TERMINATOR='$'

# Make username blink if we are logged in as root
if is-root-user; then
	USERNAME_COLOR="$USERNAME_COLOR\\[$(tput blink)\\]"
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
__add_label_if_logged_in_as__ root
__say_that_we_are__ "Leaving" "$THIS_FILE_NAME" "$FCOLOR_BRIGHT_BLUE" "$FCOLOR_YELLOW"
echo

# Restore the name of the current file to the script that sourced this one
THIS_FILE_NAME=$FILE_THAT_SOURCED_BASHRC
