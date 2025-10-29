if [[ -v __MY_INCLUDE_DIR__ ]]; then
    return 0
fi

source "$(dirname "${BASH_SOURCE[0]}")/initial_utility_functions_for_paths.sh"

function get_my_include_dir() {
	unset -f "$FUNCNAME"
	local fullPath="$(get_path_keep_symlinks_to "${BASH_SOURCE[0]}")"
	local initializationFolder="$(dirname "$fullPath")"
	dirname "$initializationFolder"
}

unset_on_exit __MY_INCLUDE_DIR__
__MY_INCLUDE_DIR__="$(get_my_include_dir)"