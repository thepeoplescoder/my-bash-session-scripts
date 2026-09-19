$__PLATFORM_IS_WINDOWS__ && return 1
[ -v is_pyenv_for_windows ] && ! $is_pyenv_for_windows && command_exists pyenv && eval "$(pyenv virtualenv-init -)"
