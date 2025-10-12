function __main__() {
	unset -f "$FUNCNAME"

	command_exists 'dircolors' || return 1

	local dircolorsFile=$(get_dircolors_file)

	create_this_file_if_it_does_not_exist "$dircolorsFile"
	set_LS_COLORS_using_this_file         "$dircolorsFile"

	true
}

function get_dircolors_file() {
	unset -f "$FUNCNAME"
	echo "$HOME/.dircolors"		# This line echoes the location of your dircolors file.
}

function create_this_file_if_it_does_not_exist() {
	unset -f "$FUNCNAME"
	[[ ! -f "$1" ]] && dircolors --print-database > "$1"
}

function set_LS_COLORS_using_this_file {
	unset -f "$FUNCNAME"
	eval "$(dircolors "$1")"
}

__main__