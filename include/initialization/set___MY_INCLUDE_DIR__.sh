if [[ -v __MY_INCLUDE_DIR__ ]]; then
    return 0
fi

source "$(dirname "${BASH_SOURCE[0]}")/initial_utility_functions_for_paths.sh"

unset_on_exit __MY_INCLUDE_DIR__
__MY_INCLUDE_DIR__="$(get_my_include_dir)"