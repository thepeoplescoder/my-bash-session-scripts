if [[ -v __LOADERS_SLASH_SCRIPTS_SLASH_ADDITIONAL_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LOADERS_SLASH_SCRIPTS_SLASH_ADDITIONAL_DOT_SH__
__LOADERS_SLASH_SCRIPTS_SLASH_ADDITIONAL_DOT_SH__="$(get_this_file_name)"

source "$__MY_INCLUDE_DIR__/libraries/_.sh"

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Loading $(__ansi__ bright green)additional$(__theme__ normal) scripts...$(__ansi__ reset)"

unset_on_exit ADDITIONAL_SCRIPTS_LOCATION
ADDITIONAL_SCRIPTS_LOCATION="$BASH_SESSION_SCRIPTS_HOME/$ADDITIONAL_SCRIPTS_DIRECTORY"

if [[ -d "$ADDITIONAL_SCRIPTS_LOCATION" ]]; then
	_push_indent
		declare -a __MY_ADDITIONAL_SCRIPTS_SAVED_ARGS__

		for shellScript in "$ADDITIONAL_SCRIPTS_LOCATION"/*; do
			! is_sourceable_or_emittable "$shellScript" && continue

			__add_username_label_if_logged_in_as__ root
			echo -n "$(__theme__ normal)Loading "
			echo -n "$(__theme__ highlight)$(basename $shellScript)"
			echo    "$(__theme__ normal)...$(__ansi__ reset)"
			pushd "$PWD" > /dev/null

			source "$(dirname "${BASH_SOURCE[0]}")/load_additional_script.sh" "$shellScript"

			popd         > /dev/null
		done

		unset shellScript
	_pop_indent
fi

__add_username_label_if_logged_in_as__ root
echo "$(__ansi__ bright green)Additional$(__theme__ normal) scripts loaded.$(__ansi__ reset)"