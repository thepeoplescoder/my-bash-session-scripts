if [[ -v __LIBRARIES_SLASH_USERS_DOT_SH__ ]]; then
    return 0
fi

unset_on_exit __LIBRARIES_SLASH_USERS_DOT_SH__
__LIBRARIES_SLASH_USERS_DOT_SH__="$(get_this_file_name)"

source "$(dirname "${BASH_SOURCE[0]}")/text_io/_.sh"         # for __ansi__, _indent

unset_on_exit is_root_user
function is_root_user() {
    if [[ -z "$1" ]]; then
        (( EUID == 0 ))
    else
        [[ "$1" == "root" ]]
    fi
}

unset_on_exit __add_username_label_if_logged_in_as__
function __add_username_label_if_logged_in_as__() {
    if [ "$USER" == "$1" ]; then
        __ansi__ default
        echo -n "($1) "
    fi
    _indent
}
