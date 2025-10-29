if [[ -v __LIBRARIES_SLASH_COMMANDS_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_SLASH_COMMANDS_DOT_SH__
__LIBRARIES_SLASH_COMMANDS_DOT_SH__=$(get_this_file_name)

unset_on_exit command_exists
function command_exists() {
    command -v "$@" &> /dev/null
}

unset_on_exit get_interpreter_for
function get_interpreter_for() {
    case "$1" in
        *.py) echo "python"   ;;
        *.js) echo "node"     ;;
        *.ts) echo "deno run" ;;
        *.rb) echo "ruby"     ;;
        *.pl) echo "perl"     ;;
    esac
}