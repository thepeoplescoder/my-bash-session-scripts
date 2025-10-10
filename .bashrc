#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function start_dotBashRc() {
	unset -f "$FUNCNAME"

	__bootstrap_initial_functionality_for_dotBashRc__

	if [[ "$(echo $PATH)" == "" ]]; then
		export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
	fi

	__enter_this_file__

	if __finish_bootstrapping_after_calling__enter_this_file__; then

		# Load starting scripts if they exist (namely functions and aliases)
		# Needed for functions such as __bash_sessionstart_notify__, prepend_to_PATH_if_it_exists
		__load_starting_scripts__
		prepend_to_PATH_if_it_exists ~/bin

		main_dotBashRc
	fi

	__leave_this_file__

	if [[ "$dotBashProfile" ]]; then
		unset dotBashProfile
		__call_this_at_the_very_end__
	fi
}

function main_dotBashRc() {
	unset -f "$FUNCNAME"

	__bash_sessionstart_notify__ "Running the rest of"; echo
	__load_additional_scripts__
	__load_ending_scripts__
	__bash_sessionstart_notify__ "Leaving"; echo
}

function __load_starting_scripts__() {
	unset -f "$FUNCNAME"

	local scriptName
	local shellScript

	for scriptName in "${STARTING_SCRIPTS[@]}"; do
		shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
		if [[ -f "$shellScript" && -r "$shellScript" ]]; then
			source $shellScript
		fi
	done

	__ansi__ reset
	__add_username_label_if_logged_in_as__ root
	echo "$(__theme__ normal)Starting scripts loaded."
}

function __load_additional_scripts__() {
	unset -f "$FUNCNAME"

	local ADDITIONAL_SCRIPTS_LOCATION="$BASH_SESSION_SCRIPTS_HOME/$ADDITIONAL_SCRIPTS_DIRECTORY"
	local shellScript

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
	fi
}

function __load_ending_scripts__() {
	unset -f "$FUNCNAME"

	local scriptName
	local shellScript

	for scriptName in "${ENDING_SCRIPTS[@]}"; do
		shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
		if [[ -f "$shellScript" && -r "$shellScript" ]]; then
			source $shellScript
		fi
	done
}

function __bootstrap_initial_functionality_for_dotBashRc__() {
	unset -f "$FUNCNAME"

	function is_bashrc_sourced_by_dot_bash_profile() {
		unset -f "$FUNCNAME"
		exists_in_array "$HOME/.bash_profile" "${BASH_SOURCE[@]}"
	}

	function exists_in_array() {
		array_find "$1" "${@:2}" &> /dev/null
	}

	function array_find() {
		local needle="$1"
		shift

		local currentItem
		local index=0
		for currentItem in "$@"; do
			if [[ "$currentItem" == "$needle" ]]; then
				echo "$index"
				return 0
			fi
			index=$(( $index + 1 ))
		done

		return 1
	}

	function parse_unindented_function() {
		sed -n '/^function *'"$1"' *() *{/,/^}/p'
	}

	if ! is_bashrc_sourced_by_dot_bash_profile; then
		dotBashProfile="$(cat ~/.bash_profile)"
		eval "$(echo "$dotBashProfile" | parse_unindented_function __bootstrap_initial_functionality_for_dotBashProfile__)"
		__bootstrap_initial_functionality_for_dotBashProfile__
	fi

	unset_on_exit exists_in_array
	unset_on_exit array_find
	unset_on_exit parse_unindented_function

	function __finish_bootstrapping_after_calling__enter_this_file__() {
		unset -f "$FUNCNAME"

		# These must be done *after* __enter_this_file__ is called.
		if [[ "$dotBashProfile" ]]; then
			eval "$(echo "$dotBashProfile" | parse_unindented_function __load_text_io_functionality__)"
			eval "$(echo "$dotBashProfile" | parse_unindented_function __load_required_environment_variables__)"

			__load_text_io_functionality__

			if __load_required_environment_variables__; then
				__add_username_label_if_logged_in_as__ root
				echo "$(__theme__ normal)Bootstrapping from $(__theme__ highlight)~/.bash_profile$(__theme__ normal) complete."
				__ansi__ reset
			else
				false
			fi
		fi
	}
}

start_dotBashRc