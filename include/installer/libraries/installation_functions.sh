if [[ -v __INSTALLER_SLASH_INSTALLATION_FUNCTIONS_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_INSTALLATION_FUNCTIONS_DOT_SH__="$(get_this_file_name)"

for __library__ in \
    "$__MY_INCLUDE_DIR__/libraries/_.sh" \
    \
    "$(dirname "${BASH_SOURCE[0]}")/dry_run.sh"\
    \
    "$(dirname "${BASH_SOURCE[0]}")/errors.sh" \
    "$(dirname "${BASH_SOURCE[0]}")/text_and_color.sh" \
    "$(dirname "${BASH_SOURCE[0]}")/file_io.sh" \
    \
    "$(dirname "${BASH_SOURCE[0]}")/preinstall_warning.sh" \
    \
    "$__MY_INCLUDE_DIR__/installer/functions/_.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

function the_user_wants_to_install_in() {
    __beep__
    show_warning_message
    ask_user_if_they_are_sure_about_continuing
}

function ask_user_if_they_are_sure_about_continuing() {
    __ansi__ bright red
    echo -n "Are you sure you want to continue (y/N)? "
    local choice
    read choice
    __ansi__ reset
    echo

    [[ "$choice" == "y" || "$choice" == "Y" ]]
}

function fail_fast_do_the_install_in() {
    dry_echo "$(
        tell_user_that_we_would_be_checking_the_current_directory_against "$__REPO_DIR__"
    )"$'\n' || {
        if [[ "$(__realpath "$(__pwd)")" != "$(__realpath "$__REPO_DIR__")" ]]; then
            abort "Invariant not satisfied: current directory is not repository directory $__REPO_DIR__"
        fi
    }

    local fullPathToInstallDirectory="$1"
    local installMode="$(get_install_mode_for "$fullPathToInstallDirectory")"

    fail_fast_make_backups_of_these_session_scripts "${FILES_TO_SYMLINK[@]}"

    if [[ "$installMode" == "copy" ]]; then
        abort "Copy install no longer supported."
    fi

    local fileName

    for fileName in "${FILES_TO_SYMLINK[@]}"; do
        fail_fast_make_sure_we_destructively_source "$fullPathToInstallDirectory/$fileName" --from "$HOME/$fileName"
    done

    display_success
}

function fail_fast_make_sure_we_destructively_source() {
    local scriptToBeSourced="$1"
    local dummyFrom="$2"
    local fileWhereTheScriptWillBeSourcedFrom="$3"

    expect "$dummyFrom" --is "--from"

    local exitCode=0

    dry_echo "$(
        tell_user_that_we_would_source "$scriptToBeSourced" --from "$fileWhereTheScriptWillBeSourcedFrom"
    )" || {
        # A backup of the contents of this file should already have been created.
        # If this is a symbolic link, we need to get rid of it so we don't accidentally overwrite
        # where this file actually leads to.....causing an "infinite" loop until segfault on session start.
        [[ -L "$fileWhereTheScriptWillBeSourcedFrom" ]] && rm "$fileWhereTheScriptWillBeSourcedFrom"

        local command="echo -e \"\\nsource \\\"$scriptToBeSourced\\\"\\n\" > \"$fileWhereTheScriptWillBeSourcedFrom\""
        echo "$(__ansi__ bright blue)Running: $(__ansi__ bright yellow)$command$(__ansi__ reset)"
        eval "$command"
        exitCode=$?
    }

    (( exitCode != 0 )) && abort "Fatal error sourcing $scriptToBeSourced from $fileWhereTheScriptWillBeSourcedFrom."
}

function display_success() {
    log_echo "Success!  Restart your terminal."
}

function tell_user_that_we_would_be_checking_the_current_directory_against() {
    echo
    _push_indent
        _indent
        echo "$(__ansi__ bright blue)Would check the working directory against:"
        _push_indent
            _indent
            echo "$(__ansi__ bright yellow)$(__realpath "$1")"
        _pop_indent
        _indent
        echo "$(__ansi__ bright blue)Current working directory would be:"
        _push_indent
            _indent
            echo "$(__ansi__ bright green)$(__pwd)"
        _pop_indent
    _pop_indent
    __ansi__ reset
}

function fail_fast_make_backups_of_these_session_scripts() {
    for basenameOfSessionScript in "$@"; do
        fail_fast_make_backup_if_exists "$HOME/$basenameOfSessionScript"
    done
}

function fail_fast_make_backup_if_exists() {
    local fileToBackup="$1"
    local backupPath="$(get_backup_filename_in_same_directory "$fileToBackup")"

    local exitCode=0

    dry_echo "Would make a backup of $fileToBackup in the same directory if it exists." || {
        if is_a_readable_file "$fileToBackup"; then
            cp --verbose "$fileToBackup" "$backupPath"
            exitCode=$?
        fi
    }

    (( exitCode != 0 )) && abort "Fatal error making backup of $fullPath."
}

function tell_user_that_we_would_source() {
    local scriptToBeSourced="$1"
    local dummyFrom="$2"
    local fileWhereTheScriptToBeSourcedFrom="$3"

    expect "$dummyFrom" --is "--from"

    echo -n "$(__ansi__ bright blue)Would source "
    echo -n "$(__ansi__ bright yellow)$scriptToBeSourced "
    echo -n "$(__ansi__ bright blue)from "
    echo -n "$(__ansi__ bright yellow)$fileWhereTheScriptWillBeSourcedFrom"
}

function fail_fast_symlink() {
    local pathToTheSymlink="$1"
    local dummyTo="$2"
    local theSymlinkDestination="$3"

    expect "$dummyTo" --is "--to"

    local intendedRelativePath="$(__realpath --relative-to="$HOME" "$theSymlinkDestination")"

    local exitCode=0

    dry_echo "$(
        echo -n "$(__ansi__ bright blue)Would symlink "
        echo -n "$(__ansi__ bright yellow)$pathToTheSymlink "
        echo -n "$(__ansi__ bright blue)to "
        echo -n "$(__ansi__ bright yellow)$theSymlinkDestination "
        echo -n "$(__ansi__ bright blue)using "
        echo -n "$(__ansi__ bright green)$intendedRelativePath"
    )" || {
        ln --verbose --symbolic "$intendedRelativePath" "$pathToTheSymlink"
        exitCode=$?
    }

    (( exitCode != 0 )) && abort "Fatal error symlinking $pathToTheSymlink to $theSymlinkDestination."
}
