source "$__MY_INCLUDE_DIR__/libraries/_.sh"

if [[ "$1" != "--from" ]]; then
	echo "The self-documenting arguments are useless in execution,"
	echo "but are useful in readability and are thus required."
	return 1
fi

__add_username_label_if_logged_in_as__ root
echo -n "$(__theme__ normal)Entering "
echo -n "$(__theme__ highlight)$2"
echo    "$(__theme__ normal)...$(__ansi__ reset)"

_push_indent
    source "$__MY_INCLUDE_DIR__/loaders/scripts/load-everything.sh" "$3" "$4" "$5" "$6"
_pop_indent

__add_username_label_if_logged_in_as__ root
echo -n "$(__theme__ normal)Leaving "
echo -n "$(__theme__ highlight)$2"
echo    "$(__theme__ normal)...$(__ansi__ reset)"

