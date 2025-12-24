if [[ -f "$HOME/.cargo/env" ]]; then
	source "$HOME/.cargo/env"
else
	prepend_to_PATH_if_it_exists "$HOME/.cargo/bin"
fi

# Loads functionality/restrictions for root user
function cargo_load_root_functionality() {
	unset -f "$FUNCNAME"

	! is_root_user            && return
	! command_exists 'rustup' && return

	local rustupPath

	! rustupPath="$(type -P rustup)" && return

	local rustupOwner=$(stat -c "%U" "$rustupPath")

	is_root_user "$rustupOwner" && return

	local msg="$(
		echo -n "Please run this command from user "
		echo -n "$(__ansi__ bright green)$rustupOwner"
		echo    "$(__ansi__ reset)."
	)"
	alias rustup="echo -e '$msg'"
}

cargo_load_root_functionality
