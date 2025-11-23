unset_on_exit __dircolorsCommand
__dircolorsCommand="gdircolors"
command_exists "$__dircolorsCommand" || __dircolorsCommand="dircolors"
command_exists "$__dircolorsCommand" || return 1

function __main__() {
	unset -f "$FUNCNAME"

	local dircolorsFile="$HOME/.dircolors"

	create_this_file_if_it_does_not_exist "$dircolorsFile"
	set_LS_COLORS_using_this_file         "$dircolorsFile"

	true
}

function create_this_file_if_it_does_not_exist() {
	unset -f "$FUNCNAME"
	[[ ! -f "$1" ]] && "$__dircolorsCommand" --print-database > "$1"
}

function set_LS_COLORS_using_this_file {
	unset -f "$FUNCNAME"
	# eval "$(dircolors "$1")"
	"$__dircolorsCommand" "$1"
	echo
	[[ "$__OS__" == "bsd" ]] && command_exists "opendircolors" && opendircolors -b "$1"
}

__main__