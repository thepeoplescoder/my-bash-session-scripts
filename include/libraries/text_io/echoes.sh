if [[ -v __LIBRARIES_SLASH_TEXT_IO_SLASH_ECHOES_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_SLASH_TEXT_IO_SLASH_ECHOES_DOT_SH__
__LIBRARIES_SLASH_TEXT_IO_SLASH_ECHOES_DOT_SH__=$(get_this_file_name)

unset_on_exit __MY_BASH_SESSION_SCRIPTS_VERBOSE__

unset_on_exit is_verbose
function is_verbose() {
    case "${MY_BASH_SESSION_SCRIPTS_VERBOSE:-1}" in
        0|false|no|off)
            return 1
            ;;
    esac

    return 0

    ######################################
    ## we have a lot to work on here... ##
    ## for now, i'm leaving it alone.   ##
    ######################################

    local key

    case "${__MY_BASH_SESSION_SCRIPTS_VERBOSE__:-1}" in
        0|false|no|off)
            return 1
            ;;
    esac

    if [[ -t 0 ]]; then
        IFS= read -rsn1 -t 0.0005 key || true
        if [[ "$key" == $'\x7f' || "$key" == $'\x08' ]]; then
            __MY_BASH_SESSION_SCRIPTS_VERBOSE__=0
            __ansi__ reset
            return 1
        fi
    fi

    return 0
}

unset_on_exit _my_echo
function _my_echo() {
    if is_verbose; then
        builtin echo "$@"
    else
        return 0
    fi
}
