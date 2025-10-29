if [[ -v __INSTALLER_SLASH_ERRORS_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_ERRORS_DOT_SH__="$(get_this_file_name)"

for __library__ in \
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

function tell_user_to_delete_this_repository_and_clone_it_again() {
    error_echo "It appears as if your clone of the repository was compromised."
    error_echo "Please delete $__REPO_DIR__ and rerun the install script from a fresh clone."
}

function abort() {
    error_echo "$@"
    exit 99
}
