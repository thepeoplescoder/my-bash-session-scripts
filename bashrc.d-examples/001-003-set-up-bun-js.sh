function __main__() {
	unset -f "$FUNCNAME"

	set_BUN_INSTALL_and_update_PATH

	true
}

function set_BUN_INSTALL_and_update_PATH() {
	unset -f "$FUNCNAME"
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
}

__main__