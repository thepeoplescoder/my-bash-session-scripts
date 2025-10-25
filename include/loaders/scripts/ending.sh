if [[ -v __LOADERS_SLASH_SCRIPTS_SLASH_ENDING_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LOADERS_SLASH_SCRIPTS_SLASH_ENDING_DOT_SH__
__LOADERS_SLASH_SCRIPTS_SLASH_ENDING_DOT_SH__="$(get_this_file_name)"

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Loading $(__ansi__ bright green)ending$(__theme__ normal) scripts...$(__ansi__ reset)"

_push_indent

	for scriptName in "${ENDING_SCRIPTS[@]}"; do
		shellScript="$BASH_SESSION_SCRIPTS_HOME/$scriptName"
		is_a_readable_file "$shellScript" && source "$shellScript"
		unset shellScript
	done
	unset scriptName

_pop_indent

__add_username_label_if_logged_in_as__ root
echo "$(__ansi__ bright green)Ending$(__theme__ normal) scripts loaded.$(__ansi__ reset)"