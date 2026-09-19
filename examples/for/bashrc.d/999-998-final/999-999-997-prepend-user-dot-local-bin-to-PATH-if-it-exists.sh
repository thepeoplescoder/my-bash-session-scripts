$__PLATFORM_IS_WINDOWS__ && prepend_to_PATH_if_it_exists "$(cygpath -u "$USERPROFILE")/.local/bin"
prepend_to_PATH_if_it_exists ~/.local/bin
