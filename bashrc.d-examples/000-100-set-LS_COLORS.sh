function __main__() {
	unset -f "$FUNCNAME"

	command_exists 'dircolors' || return 1

	local dircolorsFile="$HOME/.dircolors"

	create_this_file_if_it_does_not_exist "$dircolorsFile"
	set_LS_COLORS_using_this_file         "$dircolorsFile"

	true
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