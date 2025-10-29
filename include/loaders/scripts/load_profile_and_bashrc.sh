if [[ -v __LOADERS_SLASH_SCRIPTS_SLASH_LOAD_PROFILE_AND_BASHRC_DOT_SH__ ]]; then
    return 0
fi

unset_on_exit __LOADERS_SLASH_SCRIPTS_SLASH_LOAD_PROFILE_AND_BASHRC_DOT_SH__
__LOADERS_SLASH_SCRIPTS_SLASH_LOAD_PROFILE_AND_BASHRC_DOT_SH__="$(get_this_file_name)"

source "$__MY_INCLUDE_DIR__/libraries/_.sh"

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Entering $(__theme__ highlight)$(get_this_file_name_displayable)$(__theme__ normal)...$(__ansi__ reset)"

_push_indent
    [[ -f ~/.profile ]] && . ~/.profile
    [[ -f ~/.bashrc ]]  && . ~/.bashrc
_pop_indent

__add_username_label_if_logged_in_as__ root
echo "$(__theme__ normal)Leaving $(__theme__ highlight)$(get_this_file_name_displayable)$(__theme__ normal)...$(__ansi__ reset)"
