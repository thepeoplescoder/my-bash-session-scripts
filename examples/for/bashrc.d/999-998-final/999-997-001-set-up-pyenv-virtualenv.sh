$__PLATFORM_IS_WINDOWS__ && return 1
command_exists pyenv && eval "$(pyenv virtualenv-init -)"
