if [[ -v __LIBRARIES_SLASH_COMMANDS_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_SLASH_COMMANDS_DOT_SH__
__LIBRARIES_SLASH_COMMANDS_DOT_SH__=$(get_this_file_name)

unset_on_exit get_interpreter_for
function get_interpreter_for() {
    local target="$__MY_INCLUDE_DIR__/../extensions-to-runners/$(get_extension_without_dot "$1")"

    [[ -f "$target" ]] && cat "$target"
}
