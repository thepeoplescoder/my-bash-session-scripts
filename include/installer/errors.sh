if [[ -v __INSTALLER_SLASH_ERRORS_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_ERRORS_DOT_SH__="$(realpath "${BASH_SOURCE[0]}")"

for __library__ in \
    "$__MY_INCLUDE_DIR__/initialization/_.sh" \
    \
    "$__MY_INCLUDE_DIR__/libraries/text_io/_.sh" \
    \
    "$(dirname "${BASH_SOURCE[0]}")/text_and_color.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

function complain_that_we_are_not_directly_in_home() {
    local d="$__REPO_DIR__"
    error_echo "$(basename "$d") must be located in your home directory!"
    error_echo "It is currently located in $(dirname "$d")."
    error_echo
}

function tell_user_to_run_script_in_repo_directory_and_exit() {
    error_echo "Please run this script in the directory that the repository "
    error_echo "was cloned from."
    error_echo
}

function abort() {
    error_echo "$@"
    exit 99
}
