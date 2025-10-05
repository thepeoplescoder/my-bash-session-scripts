#
# ~/.bashrc
#

###############
##           ##
##   Entry   ##
##           ##
###############

dotBashProfile=~/.bash_profile
dataSource=$dotBashProfile

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Create the sourced file stack if it hasn't been created
eval "$(awk '
	/# BASH_PROFILE_createStack_start/ {f=1; next}
	/# BASH_PROFILE_createStack_end/   {f=0}
	f
' $dataSource)"

# Create the color stack if it hasn't been created
eval "$(awk '
	/# BASH_PROFILE_colorStack_start/ {f=1; next}
	/# BASH_PROFILE_colorStack_end/   {f=0}
	f
' $dataSource)"

# Keep track of where we are.
__enter_this_file__

##########################
##                      ##
##   Helper Functions   ##
##                      ##
##########################

# To help clean things up.
function __bash_sessionstart_notify__() {
	if [[ "$2" == "" ]]; then
		x="$(__this_file_name__)"
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

####################################
##                                ##
##   Load Initial Configuration   ##
##                                ##
####################################

# Make sure we have the location of our scripts before doing ANYTHING.
if [[ "$BASH_SESSION_SCRIPTS_HOME" == "" ]]; then
	eval "$(grep -E '^BASH_SESSION_SCRIPTS_HOME_FILE=.*' $dataSource | head -n 1)"
	BASH_SESSION_SCRIPTS_HOME=$(cat "$BASH_SESSION_SCRIPTS_HOME_FILE")
fi

# We now genuinely care that BASH_SESSION_SCRIPTS_HOME *must* point to a directory.
# Use the same directory checking code in ~/.bash_profile.
eval "$(awk '
	/# BASH_SESSION_SCRIPTS_HOME_directoryCheck_start/ {f=1; next}
	/# BASH_SESSION_SCRIPTS_HOME_directoryCheck_end/   {f=0}
	f
' $dataSource)"

# Add user's ~/bin to PATH if it exists
USERS_BIN="$HOME/bin"
[[ -d "$USERS_BIN" ]] && export PATH="$USERS_BIN:$PATH"

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
		echo "In $(__this_file_name__):"
		echo
		echo "   \$INITIAL_LOCAL_VARIABLES_PATH not declared in $sourceFile."
		echo
		echo "   Please put this declaration in $sourceFile, pointing to the"
		echo "   location of the file containing the initial local variable declarations."
		echo
		return
	fi

	# Now we can load the variables.
	__bash_sessionstart_notify__ "Loading initial local variables from" "$(__this_file_name__)"; echo
	source $INITIAL_LOCAL_VARIABLES_PATH
fi

##########################
##                      ##
##   Starting Scripts   ##
##                      ##
##########################

# Load starting scripts if they exist
for scriptName in "${STARTING_SCRIPTS[@]}"; do
	shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
	if [[ -f "$shellScript" && -r "$shellScript" ]]; then
		source $shellScript
	fi
	unset shellScript
done

############################
##                        ##
##   Additional Scripts   ##
##                        ##
############################

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

########################
##                    ##
##   Ending Scripts   ##
##                    ##
########################

# Load ending scripts
for scriptName in "${ENDING_SCRIPTS[@]}"; do
	shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
	if [[ -f "$shellScript" && -r "$shellScript" ]]; then
		source $shellScript
	fi
	unset shellScript
done

##############
##          ##
##   Exit   ##
##          ##
##############

# Let user know we're leaving
__bash_sessionstart_notify__ "Leaving"; echo

# Blank line to keep things somewhat pretty
[[ "${BASH_SOURCE[1]}" == "" ]] && echo

# Expose this

# Restore the name of the current file to the script that sourced this one
__leave_this_file__
