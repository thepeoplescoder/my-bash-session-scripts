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

define_aliases_for_cargo_installed_apps_here