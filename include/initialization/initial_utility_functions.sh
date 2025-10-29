if [[ -v __INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_DOT_SH__ ]]; then
	return 0
fi

__INITIALIZATION_SLASH_INITIAL_UTILITY_FUNCTIONS_DOT_SH__="$(get_this_file_name)"

function is_top_level_or_sourced() {
	[[ ! "${FUNCNAME[2]:-}" || "${FUNCNAME[2]}" == "source" ]]
}

function expect() {
    local value="$1"
    local dummyIs="$2"
    local expectedValue="$3"

    [[ "$dummyIs" == "--is"           ]] || abort "${FUNCNAME[0]}: --is expected."
    [[ "$value"   == "$expectedValue" ]] || abort "${FUNCNAME[1]} $expectedValue expected."
}