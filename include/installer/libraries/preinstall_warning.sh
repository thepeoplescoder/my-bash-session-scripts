if [[ -v __INSTALLER_SLASH_PREINSTALL_WARNING_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_PREINSTALL_WARNING_DOT_SH__="$(get_this_file_name)"

for __library__ in \
    "$__MY_INCLUDE_DIR__/libraries/_.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

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

function show_files_to_be_tampered_with() {
    __ansi__ color yellow
    local file
    for file in "${FILES_TO_SYMLINK[@]}"; do
        echo "   ~/$file"
    done
    echo
}
