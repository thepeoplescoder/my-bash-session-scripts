#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set a PATH for interactive shell if one does not exist.
export PATH
if [[ "$PATH" == "" ]]; then
	PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
fi

############################################
##                                        ##
##   Bootstrapping from ~/.bash_profile   ##
##                                        ##
############################################

# Checks to see if we were sourced by .bash_profile
function is_bashrc_sourced_by_dot_bash_profile() {
	[[ "${#BASH_SOURCE[@]}" -ge 2 ]] && [[ "${BASH_SOURCE[2]}" == *"/.bash_profile" ]]
}

# Bootstrap some functionality if we weren't sourced by .bash_profile
if ! is_bashrc_sourced_by_dot_bash_profile; then
	dotBashProfile="$(cat ~/.bash_profile)"

	function __load_section__() {
		local section=$1
		awk "
			/# !BEGIN_SECTION $section/ {f=1; next}
			/# !END_SECTION $section/   {f=0}
			f == 1 {print \$0}
		"
	}

	eval "$(echo "$dotBashProfile" | __load_section__ cleanup)"
	eval "$(echo "$dotBashProfile" | __load_section__ sourced-file-stack)"
	eval "$(echo "$dotBashProfile" | __load_section__ colors)"
	eval "$(echo "$dotBashProfile" | __load_section__ indented-echo)"
fi

# unset_on_exit should now be defined at this point.
unset_on_exit is_bashrc_sourced_by_dot_bash_profile

#########################################################
##                                                     ##
##   Load Initial Configuration and Starting Scripts   ##
##                                                     ##
#########################################################

# Keep track of where we are
__enter_this_file__

# These must be done *after* __enter_this_file__ is called.
if ! is_bashrc_sourced_by_dot_bash_profile; then
	eval "$(echo "$dotBashProfile" | __load_section__ BASH_SESSION_SCRIPTS_HOME)"
	eval "$(echo "$dotBashProfile" | __load_section__ BASH_SESSION_SCRIPTS_HOME-directory-check)"
	eval "$(echo "$dotBashProfile" | __load_section__ initial-local-variables)"

	unset -f __load_section__
	unset dotBashProfile
fi

msgPrefix=''
if ! is_bashrc_sourced_by_dot_bash_profile; then
	msgPrefix="Bootstrapping from $(__theme__ highlight)~/.bash_profile$(__theme__ normal) complete."$'\n'
fi

# Load starting scripts if they exist (namely functions and aliases)
for scriptName in "${STARTING_SCRIPTS[@]}"; do
	shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
	if [[ -f "$shellScript" && -r "$shellScript" ]]; then
		source $shellScript
	fi
	unset shellScript
done
unset scriptName
msgPrefix="${msgPrefix}$(__ansi__ reset)$(__add_username_label_if_logged_in_as__ root)$(__theme__ normal)Starting scripts loaded."$'\n'

# We can now do this
__bash_sessionstart_notify__ "${msgPrefix}$(__ansi__ reset)$(__add_username_label_if_logged_in_as__ root)$(__theme__ normal)Running the rest of"; echo
prepend_to_PATH_if_it_exists ~/bin

unset msgPrefix

############################
##                        ##
##   Additional Scripts   ##
##                        ##
############################

# Load any additional scripts if they exist
ADDITIONAL_SCRIPTS_LOCATION="$BASH_SESSION_SCRIPTS_HOME/$ADDITIONAL_SCRIPTS_DIRECTORY"
if [[ -d "$ADDITIONAL_SCRIPTS_LOCATION" ]]; then
	_push_indent
	for shellScript in "$ADDITIONAL_SCRIPTS_LOCATION"/*; do
		if [[ -f "$shellScript" && -r "$shellScript" ]]; then
			iecho -n "$(__theme__ normal)Loading "
			echo  -n "$(__theme__ highlight)$(basename $shellScript) "
			echo  -n "$(__theme__ normal). . . "
			source $shellScript
			echo     "$(__theme__ normal)done!$(__ansi__ reset)"
		fi
	done
	_pop_indent
	unset shellScript
fi
unset ADDITIONAL_SCRIPTS_LOCATION

########################
##                    ##
##   Ending Scripts   ##
##                    ##
########################

# Load ending scripts (terminal_prompt gets loaded here)
for scriptName in "${ENDING_SCRIPTS[@]}"; do
	shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
	if [[ -f "$shellScript" && -r "$shellScript" ]]; then
		source $shellScript
	fi
	unset shellScript
done
unset scriptName

##############
##          ##
##   Exit   ##
##          ##
##############

# Let user know we're leaving
__bash_sessionstart_notify__ "Leaving"; echo

# Restore the name of the current file to the script that sourced this one
__leave_this_file__

# non-login shells get cleanup done here.
if ! is_bashrc_sourced_by_dot_bash_profile; then
	__call_this_at_the_very_end__
fi
