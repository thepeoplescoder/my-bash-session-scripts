BUN_INSTALL="$HOME/.bun"

if ! is_a_directory "$BUN_INSTALL"; then
    unset BUN_INSTALL
    return 0
fi

export BUN_INSTALL
prepend_to_PATH_if_it_exists "$BUN_INSTALL/bin"

