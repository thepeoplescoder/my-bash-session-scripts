if [[ -v __INSTALLER_SLASH_INTEGRITY_CHECKING_FUNCTIONS_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_INTEGRITY_CHECKING_FUNCTIONS_DOT_SH__="$(get_this_file_name)"

for __library__ in \
    "$__MY_INCLUDE_DIR__/libraries/_.sh" \
    "$(dirname "${BASH_SOURCE[0]}")/errors.sh" \
    "$(dirname "${BASH_SOURCE[0]}")/text_and_color.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

function find_first_missing_directory_in_list() {
    local -a tempCopy=()
    local item
    for item in "${DIRECTORY_LIST[@]}"; do
        tempCopy+=("$__REPO_DIR__/$item")
    done

    find_first_match_of not_a_directory --in "${tempCopy[@]}"
}

function find_first_missing_file_in_list() {
    local -a tempCopy=()
    local item
    for item in "${FILE_LIST[@]}"; do
        tempCopy+=("$__REPO_DIR__/$item")
    done

    find_first_match_of not_a_readable_file --in "${tempCopy[@]}"
}

function find_first_match_of() {
    local ourMetaphoricalNeedleIs="$1"
    local dummyIn="$2"

    expect "$dummyIn" --is "--in"

    local haystack="${@:3}"

    local item
    for item in $haystack; do
        if $ourMetaphoricalNeedleIs "$item"; then
            echo "$item"
            return 0
        fi
    done
    false
}

function not_an_existing_command() {
    ! command_exists "$1"
}

function not_a_directory() {
    ! is_a_directory "$1"
}

function is_a_directory() {
    [[ -d "$1" ]]
}

function not_a_readable_file() {
    ! is_a_readable_file "$1"
}

function is_a_readable_file() {
    [[ -f "$1" && -r "$1" ]]
}
