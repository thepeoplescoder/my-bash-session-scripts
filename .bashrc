#
# ~/.bashrc
#

if [ -v __MY_DOT_BASHRC__ ]; then
    return 0
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

__MY_DOT_BASHRC__="$(realpath "${BASH_SOURCE[0]}")"
__MY_DOT_BASHRC_DIR__="$(dirname "$__MY_DOT_BASHRC__")"

source "$__MY_DOT_BASHRC_DIR__/include/initialization/_.sh"

prepend_to_PATH_if_it_exists ~/bin

unset_on_exit __MY_DOT_BASHRC__
unset_on_exit __MY_DOT_BASHRC_DIR__

source "$__MY_INCLUDE_DIR__/libraries/_.sh"

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Entering $(__theme__ highlight)$(get_this_file_name_displayable)$(__theme__ normal)...$(__ansi__ reset)"

_push_indent

    source "$__MY_INCLUDE_DIR__/loaders/environment_variables/_.sh"

    source "$__MY_INCLUDE_DIR__/loaders/scripts/starting.sh"
    source "$__MY_INCLUDE_DIR__/loaders/scripts/additional.sh"
    source "$__MY_INCLUDE_DIR__/loaders/scripts/ending.sh"

_pop_indent

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Leaving $(__theme__ highlight)$(get_this_file_name_displayable)$(__theme__ normal)...$(__ansi__ reset)"

on_exit