if [[ -v __INSTALLER_SLASH_FILE_IO_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_FILE_IO_DOT_SH__="$(get_this_file_name)"

for __library__ in \
    "$__MY_INCLUDE_DIR__/libraries/_.sh" \
    "$__MY_INCLUDE_DIR__/installer/functions/_.sh" \
    \
    "$(dirname "${BASH_SOURCE[0]}")/text_and_color.sh" \
    "$(dirname "${BASH_SOURCE[0]}")/integrity_checking_functions.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

# function put_the_relevant_repository_files_in() {
#     if [[ "$(__realpath "$(__pwd)")" != "$(__realpath "$__REPO_DIR__")" ]]; then
#         abort "Invariant not satisfied: current directory is not repository directory $__REPO_DIR__"
#     fi

#     local originalInstallationDestinationFromCommandLine="$1"
#     local fullPathToInstallDirectory="$(
#         get_full_path_without_expanding_symlinks "$INITIAL_PWD/$originalInstallationDestinationFromCommandLine" __cd
#     )"

#     if ! make_path_if_it_does_not_exist "$INITIAL_PWD" "$1"; then
#         echo "TODO: fix this."
#     fi

# }

# function make_path_if_it_does_not_exist() {
#     local fullPathToDestination="$1"
#     local prefix="$1"
#     local originalInstallDestinationDirectory="$2"
#     local fullPathToDirectory="$(get_full_path_without_expanding_symlinks "$prefix/$originalInstallDestinationDirectory" __cd)"

#     [ -d "$fullPathToDestination" ] && return 0

#     echo "Making directory $fullPath..."
#     with_post_delay mkdir --verbose --parents "$fullPath"
# }

function is_directory_empty() {
    [[ -z "$(find "$1" -mindepth 1 -print -quit)" ]]
}

# function nondestructively_symlink_required_files_to_users_home_directory_from() {
#     local installDir="$(__realpath "$1")"
#     local oldDir="$(__pwd)"
#     local file

#     chdir_and_show "$HOME"

#     for file in "${FILES_TO_SYMLINK[@]}"; do
#         nondestructively_dispose_of_old_name_and_make_new_symlink_in_home_directory_using "$installDir/$file"
#     done

#     chdir_and_show "$oldDir"
# }

function chdir_and_show() {
    local currentDirectory="$(__pwd)"

    # not_a_directory "$1" && return 1

    local directoryToChangeTo="$(get_full_path_without_expanding_symlinks "$1" __cd)"
    [[ "$directoryToChangeTo" != "$currentDirectory" ]] && chdir_and_show_nocheck "$directoryToChangeTo"
}

function chdir_and_show_nocheck() {
    __cd "$1"
    local cdRetval=$?
    if [[ $cdRetval -eq 0 ]]; then
        echo -n "$(__ansi__ bright blue)Current working directory is now "
        echo -n "$(__ansi__ bright cyan)$1"
        echo    "$(__ansi__ bright blue)."
        __ansi__ reset
        echo
    fi
    return $cdRetval
}

function nondestructively_dispose_of_old_name_and_make_new_symlink_in_home_directory_using() {
    # This invariant must be maintained to keep the script simple.
    if [[ "$(__pwd)" != "$HOME" ]]; then
        abort "$FUNCNAME should only be called from $HOME."
    fi

    local originalFile="$(get_full_path_without_expanding_symlinks "$1" __cd)"
    local basenameOfFile="$(basename "$originalFile")"

    local fileAtHome="./$basenameOfFile"
    local backupFile="./$(find_rotation_target "$basenameOfFile" 999)"

    local fileAtHomeDisplayable="$(get_displayable_path "$fileAtHome")"
    local backupFileDisplayable="$(get_displayable_path "$backupFile")"

    local isCopyNeeded=false
    if [[ -r "$fileAtHome" ]]; then
        isCopyNeeded=true
    fi

    if $isCopyNeeded; then
        echo    "$(__ansi__ bright white)Found: $(__ansi__ bright blue)$fileAtHomeDisplayable"
        _push_indent
            _indent
            echo -n "$(__ansi__ bright green)Copying "
            echo -n "$(__ansi__ bright yellow)$fileAtHomeDisplayable "
            echo -n "$(__ansi__ bright green)to "
            echo -n "$(__ansi__ bright yellow)$backupFileDisplayable"
            echo    "$(__ansi__ bright green)..."
            _push_indent
                _indent && with_post_delay cp --verbose "$fileAtHome" "$backupFile" 2> /dev/null | colorize_cp_or_ln
            _pop_indent

            _indent && log_to_console "Deleting" "$fileAtHomeDisplayable"; echo
            _push_indent
                _indent && with_post_delay rm --verbose "$fileAtHome" 2> /dev/null | colorize_rm
            _pop_indent
        _pop_indent
    fi

    local intendedRelativePath="$(__realpath --relative-to="$PWD" "$originalFile")"

    $isCopyNeeded && _push_indent
        _indent && log_to_console "Creating a symbolic link from" "$fileAtHomeDisplayable"; echo
        _push_indent
            _indent && with_post_delay ln --verbose --symbolic "$intendedRelativePath" | colorize_cp_or_ln
        _pop_indent
    $isCopyNeeded && _pop_indent
    echo
}

# function make_a_backup_of_this_file_in_the_same_directory_using_our_rotator() {
#     local fullPathToOriginalFile="$(get_full_path_without_expanding_symlinks "$1")"

#     local workingDirectory="$(dirname "$fullPathToOriginalFile")"
#     local basenameOfFile="$(basename "$fullPathToOriginalFile")"

#     local fullPathToBackupFile="$workingDirectory/$(find_rotation_target "$basenameOfFile" 999)"

#     local originalFileDisplayable="$(get_displayable_path "$fullPathToOriginalFile")"
#     local backupFileDisplayable="$(get_displayable_path "$fullPathToBackupFile")"

#     _indent
#     echo -n "$(__ansi__ bright green)Copying "
#     echo -n "$(__ansi__ bright yellow)$originalFileDisplayable "
#     echo -n "$(__ansi__ bright green)to "
#     echo -n "$(__ansi__ bright yellow)$backupFileDisplayable"
#     echo    "$(__ansi__ bright green)..."
#     _push_indent
#         _indent && with_post_delay cp --verbose "$fullPathToOriginalFile" "$fullPathToBackupFile"
#     _pop_indent
# }


