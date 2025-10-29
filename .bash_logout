#
# ~/.bash_logout
#

if [ -v __MY_DOT_BASH_LOGOUT__ ]; then
    return 0
fi

__MY_DOT_BASH_LOGOUT__="$(realpath "${BASH_SOURCE[0]}")"
__MY_DOT_BASH_LOGOUT_DIR__="$(dirname "$__MY_DOT_BASH_LOGOUT__")"