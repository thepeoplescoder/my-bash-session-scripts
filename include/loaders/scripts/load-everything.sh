source "$__MY_INCLUDE_DIR__/libraries/_.sh"
source "$__MY_INCLUDE_DIR__/loaders/environment_variables/_.sh"

if [[ "$1" != "--in" && "$3" != "--as" ]]; then
	echo "The self-documenting arguments are useless in execution,"
	echo "but are useful in readability and are thus required."
	return 1
fi

__add_username_label_if_logged_in_as__ root
echo -n "$(__ansi__ color cyan)Loading "
echo -n "$(__ansi__ bright cyan)$4"
echo    "$(__ansi__ color cyan)...$(__ansi__ reset)"

if [ ! -v ADDITIONAL_SCRIPTS_LOCATION_STACK ]; then
	unset_on_exit ADDITIONAL_SCRIPTS_LOCATION_STACK
	ADDITIONAL_SCRIPTS_LOCATION_STACK=()
fi

if [ ! -v __additionalScriptDirectory__ ]; then
	unset_on_exit __additionalScriptDirectory__
	unset_on_exit __additionalScript__
	__additionalScriptDirectory__=''
	__additionalScript__=''
fi

ADDITIONAL_SCRIPTS_LOCATION_STACK+=("$BASH_SESSION_SCRIPTS_HOME/$2")

if [[ -d "${ADDITIONAL_SCRIPTS_LOCATION_STACK[@]: -1}" ]]; then
	_push_indent
		for __additionalScriptDirectory__ in "${ADDITIONAL_SCRIPTS_LOCATION_STACK[@]: -1}"/*; do
			[[ "$(basename "$__additionalScriptDirectory__")" == .* ]] && continue
			! is_a_directory "$__additionalScriptDirectory__"          && continue

			__add_username_label_if_logged_in_as__ root
			echo -n "$(__ansi__ bright red)In "
			echo -n "$(__ansi__ bright yellow)$(basename "$__additionalScriptDirectory__")"
			echo    "$(__ansi__ bright red)...$(__ansi__ reset)"

			_push_indent

				for __additionalScript__ in "$__additionalScriptDirectory__"/*; do
					[[ "$(basename "$__additionalScript__")" == .* ]]    && continue
					! is_sourceable_or_emittable "$__additionalScript__" && continue

					__add_username_label_if_logged_in_as__ root
					echo -n "$(__theme__ normal)* "
					echo -n "$(__ansi__ bright green)$(basename "$__additionalScript__")"
					echo    "$(__ansi__ reset)"

					pushd "$PWD" > /dev/null
					source "$(dirname "${BASH_SOURCE[0]}")/load_additional_script.sh" "$__additionalScript__"
					popd         > /dev/null
				done

			_pop_indent

		done

	_pop_indent
fi

unset 'ADDITIONAL_SCRIPTS_LOCATION_STACK[${#ADDITIONAL_SCRIPTS_LOCATION_STACK[@]}-1]'

__add_username_label_if_logged_in_as__ root
echo "$(__ansi__ color cyan)Done!$(__ansi__ reset)"