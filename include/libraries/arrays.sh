if [[ -v __LIBRARIES_ARRAYS_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_ARRAYS_DOT_SH__
__LIBRARIES_ARRAYS_DOT_SH__=$(get_this_file_name)

unset_on_exit exists_in_array
function exists_in_array() {
	array_find "$1" "${@:2}" &> /dev/null
}

unset array_find
function array_find() {
	local needle="$1"
	shift
	local -a haystack=("$@")

	local currentItem
	local index=0
	for currentItem in "${haystack[@]}"; do
		if [[ "$currentItem" == "$needle" ]]; then
			echo "$index"
			return 0
		fi
		index=$(( $index + 1 ))
	done

	return 1
}

