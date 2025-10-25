if [[ -v __INSTALLER_SLASH_INTEGRITY_CHECKING_FUNCTIONS_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_INTEGRITY_CHECKING_FUNCTIONS_DOT_SH__="$(realpath "${BASH_SOURCE[0]}")"

for __library__ in \
    "$__MY_INCLUDE_DIR__/initialization/_.sh" \
    "$__MY_INCLUDE_DIR__/libraries/text_io/_.sh" \
    "$__MY_INCLUDE_DIR__/installer/errors.sh" \
    "$__MY_INCLUDE_DIR__/installer/text_and_color.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

# function make_sure_this_repository_is_directly_in_users_home() {
#     local pathToThisScript="$(get_path_to_this_script_without_expanding_symlinks)"

#     local dirnameOfThisScript="$(dirname "$pathToThisScript")"
#     local nameOfDirectoryThatThisScriptShouldBeIn="${DIRECTORY_LIST[2]}"

#     if [[ "$(basename "$dirnameOfThisScript")" != "$nameOfDirectoryThatThisScriptShouldBeIn" ]]; then
#         error_echo "Please move this script back to $nameOfDirectoryThatThisScriptShouldBeIn."; echo
#         echo
#         return 1
#     fi

#     local dirnameOfThisRepository="$(dirname "$dirnameOfThisScript")"
#     local parentDirectoryOfThisRepository="$(dirname "$dirnameOfThisRepository")"

#     if [[ "$parentDirectoryOfThisRepository" != "$HOME" ]]; then
#         complain_that_we_are_not_directly_in_home
#         return 1
#     fi

#     return 0
# }

function check_for_and_exit_if_we_find() {
    local missingItem="$($1)"
    if [[ "$missingItem" ]]; then
        error_echo "$missingItem $2"; echo
        tell_user_to_run_script_in_repo_directory_and_exit
    fi
}

function any_missing_directory_in_list() {
    at_least_one_match_exists not_a_directory "${DIRECTORY_LIST[@]}"
}

function any_missing_file_in_list() {
    at_least_one_match_exists not_a_readable_file "${FILE_LIST[@]}"
}

function at_least_one_match_exists() {
    local ourMetaphoricalNeedleIs="$1"
    local haystack="${@:2}"
    local item
    for item in $haystack; do
        if $ourMetaphoricalNeedleIs "$item"; then
            echo "$item"
            return 0
        fi
    done
    false
}

function not_a_directory() {
    ! is_a_directory "$@"
}

function is_a_directory() {
    [[ -d "$1" ]]
}

function not_a_readable_file() {
    ! is_a_readable_file "$@"
}

function is_a_readable_file() {
    [[ -f "$1" && -r "$1" ]]
}
