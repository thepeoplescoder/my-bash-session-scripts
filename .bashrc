#
# ~/.bashrc
#

if [[ -v __MY_DOT_BASHRC__ || $- != *i* ]]; then
    return 0
fi

__MY_DOT_BASHRC__="$(realpath "${BASH_SOURCE[0]}")"
__MY_DOT_BASHRC_DIR__="$(dirname "$__MY_DOT_BASHRC__")"

source "$__MY_DOT_BASHRC_DIR__/include/initialization/_.sh"

unset_on_exit __MY_DOT_BASHRC__
unset_on_exit __MY_DOT_BASHRC_DIR__

source "$__MY_INCLUDE_DIR__/loaders/scripts/run-everything.sh"   \
    --from "$( get_this_file_name_displayable               )"   \
    --in   "$( basename "${BASH_SOURCE[0]}" | sed 's/^\.//' ).d" \
    --as   "scripts"

on_exit
