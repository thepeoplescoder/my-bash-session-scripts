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

# Checks to see if a command is installed by cargo
# as of now, it is defined by checking if the executable is in
# the user's home directory.
unset_on_exit is_installed_by_cargo
function is_installed_by_cargo() {
	is_installed_in_users_dot_cargo_directory "$@"
}

# Checks to see if a command is installed in $HOME/.cargo/bin
unset_on_exit is_installed_in_users_dot_cargo_directory
function is_installed_in_users_dot_cargo_directory() {
	[[ "$(which "$1" 2> /dev/null)" == "$HOME/.cargo/bin/$1" ]]
}

# Loads functionality/restrictions for root user
function cargo_load_root_functionality() {
	unset -f "$FUNCNAME"
	is_root_user || return

	if command_exists 'rustup'; then
		local rustupPath

		if rustupPath="$(type -P rustup)"; then
			local rustupOwner=$(stat -c "%U" "$rustupPath")

			if ! is_root_user "$rustupOwner"; then
				local msg="Please run this command from user $(__ansi__ bright green)$rustupOwner$(__ansi__ reset)."
				alias rustup="echo -e '$msg'"
			fi
		fi
	fi
}

define_aliases_for_cargo_installed_apps_here
cargo_load_root_functionality
