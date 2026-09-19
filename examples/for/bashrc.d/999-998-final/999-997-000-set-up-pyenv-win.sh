$__PLATFORM_IS_WINDOWS__ || return 1

unset_on_exit __pyenv_win_root
__pyenv_win_root=''

if [[ "$PYENV" ]]; then
        __pyenv_win_root="$(cygpath -u "$PYENV" 2>/dev/null)"
        __pyenv_win_root="${__pyenv_win_root%/}"
elif [[ "$USERPROFILE" ]]; then
        __pyenv_win_root="$(cygpath -u "$USERPROFILE")/.pyenv/pyenv-win"
fi

if [[ ! -d "$__pyenv_win_root" ]]; then
        return 1
fi

prepend_to_PATH_if_it_exists "$__pyenv_win_root/bin"
prepend_to_PATH_if_it_exists "$__pyenv_win_root/shims"
