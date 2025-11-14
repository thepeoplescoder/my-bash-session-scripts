if [[ -f "$HOME/.cargo/env" ]]; then
	source "$HOME/.cargo/env"
else
	prepend_to_PATH_if_it_exists "$HOME/.cargo/bin"
fi

# This function sets the aliases for apps installed by cargo.
# to set an alias, use:
#
#    cargo_set_alias_for 'prog' 'aliasName' 'command'
#
#       or
#
#    cargo_set_alias_for 'prog' 'command'      # in this case, prog and aliasName are the same.
#
function define_aliases_for_cargo_installed_apps_here() {
	unset -f "$FUNCNAME"

	cargo_set_alias_for 'bat' 'bat.clean' 'bat -SP --style=-changes,-grid,-header-filename,-numbers,-snip'
}

# Wrapper to set an alias for an app installed by cargo.
unset_on_exit cargo_set_alias_for
function cargo_set_alias_for() {
	command_exists "$1" || return
	[[ "$3" ]] && shift
	alias "$1"="$2"
}

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

define_aliases_for_cargo_installed_apps_here
cargo_load_root_functionality
