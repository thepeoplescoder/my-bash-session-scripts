PYENV_ROOT="$HOME/.pyenv"

unset_on_exit __pyEnvPath
__pyEnvPath="$(command -v pyenv)"

if ! $__PLATFORM_IS_WINDOWS__ && [[ "$__pyEnvPath" == */pyenv-win/* ]]; then
    function pyenv() {
        echo "It was detected that pyenv-win's pyenv is the default pyenv in your PATH."
        echo "Please fix your PATH in a prior section, and ensure you have pyenv installed"
        echo "if you wish to use it."
    }
    unset PYENV_ROOT
    return 0

elif command -v pyenv 1>/dev/null 2>&1; then
    PYENV_ROOT=''

elif is_a_directory "$PYENV_ROOT"; then
    prepend_to_PATH_if_it_exists "$PYENV_ROOT/bin"
fi

if ! command_exists 'pyenv'; then
    unset PYENV_ROOT
    return 0
fi

eval "$(pyenv init - bash)"

[[ ! "$PYENV_ROOT" ]] && PYENV_ROOT="$(pyenv root)"
export PYENV_ROOT
