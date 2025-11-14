#
# ~/.bash_logout
#

if [ -v __MY_DOT_BASH_LOGOUT__ ]; then
    return 0
fi

__MY_DOT_BASH_LOGOUT__="$(realpath "${BASH_SOURCE[0]}")"
__MY_DOT_BASH_LOGOUT_DIR__="$(dirname "$__MY_DOT_BASH_LOGOUT__")"

source "$__MY_DOT_BASH_LOGOUT_DIR__/include/initialization/_.sh"

# unset_on_exit __MY_DOT_BASH_LOGOUT__
# unset_on_exit __MY_DOT_BASH_LOGOUT_DIR__

source "$__MY_INCLUDE_DIR__/loaders/scripts/run-everything.sh"   \
    --from "$( get_this_file_name_displayable               )"   \
    --in   "$( basename "${BASH_SOURCE[0]}" | sed 's/^\.//' ).d" \
    --as   "logout scripts"

# on_exit
