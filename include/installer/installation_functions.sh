if [[ -v __INSTALLER_SLASH_INSTALLATION_FUNCTIONS_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_INSTALLATION_FUNCTIONS_DOT_SH__="$(realpath "${BASH_SOURCE[0]}")"

for __library__ in \
    "$__MY_INCLUDE_DIR__/initialization/_.sh" \
    \
    "$__MY_INCLUDE_DIR__/libraries/text_io/_.sh" \
    \
    "$__MY_INCLUDE_DIR__/installer/errors.sh" \
    "$__MY_INCLUDE_DIR__/installer/text_and_color.sh" \
    "$__MY_INCLUDE_DIR__/installer/file_io.sh" \
    "$__MY_INCLUDE_DIR__/installer/with_post_delay.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

function do_the_install_in() {
    if [[ "$(realpath "$(pwd)")" != "$(realpath "$__REPO_DIR__")" ]]; then
        abort "Invariant not satisfied: current directory is not repository directory $__REPO_DIR__"
    fi

    local fullPathToInstallDirectory="$1"
    local doTheInstall=true

    local installMode="$(get_install_mode_for "$fullPathToInstallDirectory")"

    if [[ "$installMode" == "repo" ]]; then
        make_a_backup_of_the_users_
    else
        copy_the_needed_files_from_this_repository_to "$fullPathToInstallDirectory"
        nondestructively_symlink_required_files_to_users_home_directory_from "$fullPathToInstallDirectory"
        display_success
    fi

    # if [[ "$(realpath "$installDirectory")" != "$(realpath "$__REPO_DIR__")" ]]; then
    #     if ! put_the_relevant_repository_files_in "$installDirectory"; then
    #         doTheInstall=false
    #     fi
    # fi

    # $doTheInstall && (
    #     nondestructively_symlink_required_files_to_users_home_directory_from "$installDirectory"
    #     display_success
    # )
}

function get_install_mode_for() {
    local fullPathToInstallDirectory="$1"
    if [[ "$(realpath "$fullPathToInstallDirectory")" == "$(realpath "$__REPO_DIR__")" ]]; then
        echo "repo"
    else
        echo "copy"
    fi
}

function the_user_wants_to_install_in() {
    clear
    __beep__
    show_the_installation_directory_as "$1"
    show_warning_message
    ask_user_if_they_are_sure_about_continuing
}

function show_warning_message() {
    __ansi__ bright red
    echo "##############################################"
    echo "# WARNING!!!  PLEASE READ BEFORE CONTINUING. #"
    echo "##############################################"
    echo
    show_what_will_happen_to_the_files
}

function show_what_will_happen_to_the_files() {
    __ansi__ bright yellow
    echo "If the following files exist:"
    echo

    show_files_to_be_tampered_with

    __ansi__ bright yellow
    echo "they will be backed up to similarly named file with an extension of .xyz.old,"
    echo "where xyz is a value of: 000, 001, 002, 003, ..., 998, 999."
    echo
}

function show_the_installation_directory_as() {
    echo "$(__ansi__ bright white)Installing to $(__ansi__ bright green)$1"
    echo
}

function show_files_to_be_tampered_with() {
    __ansi__ color yellow
    local file
    for file in "${FILES_TO_SYMLINK[@]}"; do
        echo "   ~/$file"
    done
    echo
}

function ask_user_if_they_are_sure_about_continuing() {
    __ansi__ bright red
    echo -n "Are you sure you want to continue (y/N)? "
    local choice
    read choice
    echo

    [[ "$choice" == "y" || "$choice" == "Y" ]]
}

function display_success() {
    log_echo "Success!  Restart your terminal."
    echo
    true
}
