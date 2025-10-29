if [[ -v __INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_FOR_PATHS_DOT_SH__ ]]; then
    return 0
fi

###########################################################

unset_on_exit get_this_file_name
function get_this_file_name() {
	echo "$(get_path_keep_symlinks_to "${BASH_SOURCE[1]}")"
}

unset_on_exit get_path_keep_symlinks_to
function get_path_keep_symlinks_to() {
	local pathToThing="$1"
    shift

    local -a cd_callback=("cd")
    if [ "$1" ]; then
        cd_callback=("$@")
    fi

	local directoryToThing="$(dirname "$pathToThing")"
	echo "$(
		"${cd_callback[@]}" "$directoryToThing" || exit 
		pwd
	)/$(basename "$pathToThing")"
}

###########################################################

# set the include guard as soon as we safely can
unset_on_exit __INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_FOR_PATHS_DOT_SH__
__INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_FOR_PATHS_DOT_SH__="$(get_this_file_name)"

###########################################################

unset_on_exit get_full_path_without_expanding_symlinks
function get_full_path_without_expanding_symlinks() {
    local p="$1"
    shift

    local -a cd_callback=("cd")
    if [ "$1" ]; then
        cd_callback=("$@")
    fi

    if is_a_directory "$p"; then
        echo "$(
            "${cd_callback[@]}" "$p" || exit
            pwd
        )"

    elif is_a_readable_file "$p"; then
        echo "$(
            "${cd_callback[@]}" "$(dirname "$p")" || exit
            pwd
        )/$(basename "$p")"

    else
        echo "$p"
    fi
}

function get_displayable_path() {
    _fix "$(get_full_path_without_expanding_symlinks "$@")"
}

unset_on_exit get_this_file_name_displayable
function get_this_file_name_displayable() {
	# local result="$(get_path_keep_symlinks_to "${BASH_SOURCE[1]}")"
	# echo "$(_fix "$result")"
	_fix "$(get_path_keep_symlinks_to "${BASH_SOURCE[1]}")"
}

unset_on_exit _fix
function _fix() {
    local path="$1"
    path="${path/#$HOME/\~}"
    path="${path/#$(pwd)/.}"
    echo "$path"
}

## totally not necessary; only for late night readability ##

unset_on_exit prepend_to_PATH_if_it_exists
function prepend_to_PATH_if_it_exists() {
    is_a_directory "$1" && export PATH="$1:$PATH"
}

unset_on_exit is_a_directory
function is_a_directory() {
	[[ -d "$1" ]]
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
