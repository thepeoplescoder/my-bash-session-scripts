if [[ -v __LIBRARIES_PARSING_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_PARSING_DOT_SH__
__LIBRARIES_PARSING_DOT_SH__="$(get_this_file_name)"

unset_on_exit parse_unindented_function
function parse_unindented_function() {
	sed -n '/^function *'"$1"' *() *{ */,/^}/p'
}
