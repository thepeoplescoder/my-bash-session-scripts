SDKMAN_DIR="$HOME/.sdkman"

if ! is_a_directory "$SDKMAN_DIR"; then
    unset SDKMAN_DIR
    return 0
fi

export SDKMAN_DIR

unset_on_exit __SDKMAN_INIT_SH__
__SDKMAN_INIT_SH__="$SDKMAN_DIR/bin/sdkman-init.sh"

[[ -s "$__SDKMAN_INIT_SH__" ]] && source "$__SDKMAN_INIT_SH__"
