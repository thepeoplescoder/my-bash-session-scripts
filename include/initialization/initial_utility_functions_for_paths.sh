if [[ -v __INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_FOR_PATHS_DOT_SH__ ]]; then
    return 0
fi

###########################################################

unset_on_exit get_this_file_name
function get_this_file_name() {
	echo "$(get_path_keep_symlinks "${BASH_SOURCE[1]}")"
}

unset_on_exit _fix
function _fix() {
    local path="$1"
    path="${path/#$HOME/\~}"
    path="${path/#$(pwd)/.}"
    echo "$path"
}

unset_on_exit get_this_file_name_displayable
function get_this_file_name_displayable() {
	local result="$(get_path_keep_symlinks "${BASH_SOURCE[1]}")"
	echo "$(_fix "$result")"
}

unset_on_exit get_path_keep_symlinks
function get_path_keep_symlinks() {
	local pathToThing="$1"
	local directoryToThing="$(dirname "$pathToThing")"
	echo "$(
		cd "$directoryToThing" || exit 
		pwd
	)/$(basename "$pathToThing")"
}

unset_on_exit get_my_include_dir
function get_my_include_dir() {
	unset -f "$FUNCNAME"
	# local fullPath="$(realpath -s "${BASH_SOURCE[0]}")"
	local fullPath="$(get_path_keep_symlinks "${BASH_SOURCE[0]}")"
	local initializationFolder="$(dirname "$fullPath")"
	dirname "$initializationFolder"
}

unset_on_exit is_a_readable_file
function is_a_readable_file() {
	is_a_file "$1" && [[ -r "$1" ]]
}

unset_on_exit is_a_file
function is_a_file() {
	[[ -f "$1" ]]
}

unset_on_exit is_sourceable_or_emittable
function is_sourceable_or_emittable() {
	is_sourceable "$1" || is_emittable "$1"
}

unset_on_exit is_sourceable
function is_sourceable() {
	exists_in_array "$(get_extension "$1")" "${SOURCEABLE_EXTENSIONS[@]}" && is_a_readable_file "$1"
}

unset_on_exit is_emittable
function is_emittable() {
	if exists_in_array "$(get_extension "$1")" "${EMITTABLE_EXTENSIONS[@]}"; then
		return 0
	fi
	is_executable "$1" && [[ -f "$1" ]]
}

unset_on_exit is_executable
function is_executable() {
	[ -x "$1" ]
}

unset_on_exit get_extension
function get_extension() {
	echo "${1##*.}"
}

###########################################################

unset_on_exit __INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_FOR_PATHS_DOT_SH__
__INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_FOR_PATHS_DOT_SH__="$(get_this_file_name)"