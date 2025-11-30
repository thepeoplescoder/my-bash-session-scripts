# source "$__MY_INCLUDE_DIR__/loaders/scripts/load_profile_and_bashrc.sh"

source "$__MY_INCLUDE_DIR__/libraries/_.sh"

_push_indent
    [[ -f ~/.profile ]] && . ~/.profile
    [[ -f ~/.bashrc  ]] && . ~/.bashrc
_pop_indent