if [ ! -v PYENV_ROOT ]; then
    return 0
fi

eval "$(pyenv virtualenv-init -)"