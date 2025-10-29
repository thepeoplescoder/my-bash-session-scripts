if [[ -v __INSTALLER_SLASH_FILENAMES_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_FILENAMES_DOT_SH__="$(get_this_file_name)"

for __library__ in \
    "$__MY_INCLUDE_DIR__/libraries/_.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

