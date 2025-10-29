#
# ~/.bash_profile
#

if [ -v __MY_DOT_BASH_PROFILE__ ]; then
    return 0
fi

__MY_DOT_BASH_PROFILE__="$(realpath "${BASH_SOURCE[0]}")"
__MY_DOT_BASH_PROFILE_DIR__="$(dirname "$__MY_DOT_BASH_PROFILE__")"

source "$__MY_DOT_BASH_PROFILE_DIR__/include/initialization/_.sh"

unset_on_exit __MY_DOT_BASH_PROFILE__
unset_on_exit __MY_DOT_BASH_PROFILE_DIR__

source "$__MY_INCLUDE_DIR__/libraries/_.sh"

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Running the rest of $(__theme__ highlight)$(get_this_file_name_displayable)$(__theme__ normal)...$(__ansi__ reset)"

_push_indent
    source "$__MY_INCLUDE_DIR__/loaders/scripts/load_profile_and_bashrc.sh"
_pop_indent

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Leaving $(__theme__ highlight)$(get_this_file_name_displayable)$(__theme__ normal)...$(__ansi__ reset)"

on_exit