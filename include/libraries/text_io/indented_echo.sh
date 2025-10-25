if [[ -v __LIBRARIES_SLASH_TEXT_IO_SLASH_INDENTED_ECHO_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_SLASH_TEXT_IO_SLASH_INDENTED_ECHO_DOT_SH__
__LIBRARIES_SLASH_TEXT_IO_SLASH_INDENTED_ECHO_DOT_SH__=$(get_this_file_name)

# Export these since external scripts need them.
unset_on_exit __iecho_INDENT
unset_on_exit __iecho_INDENT_STRING
export __iecho_INDENT=0
export __iecho_INDENT_STRING="   "

unset_on_exit _indent
function _indent() {
	local i
	for (( i=0; i<__iecho_INDENT; i++ )); do
		echo -n "$__iecho_INDENT_STRING"
	done
}

unset_on_exit iecho
function iecho() {
	_indent; echo "$@"
}

unset_on_exit _push_indent
function _push_indent() {
	__iecho_INDENT=$(( __iecho_INDENT + 1 ))
}

unset_on_exit _pop_indent
function _pop_indent() {
	__iecho_INDENT=$(( __iecho_INDENT - 1 ))
	[[ $__iecho_INDENT -lt 0 ]] && __iecho_INDENT=0
}
