if [[ ! -v __MY_INCLUDE_DIR__ ]]; then
	echo "__MY_INCLUDE_DIR__ must be defined before sourcing this file."
	exit 1
fi

if [[ -v BASH_SESSION_SCRIPTS_HOME ]]; then
	return 0
fi

# This variable does NOT get unset on exit.
BASH_SESSION_SCRIPTS_HOME="$(dirname "$__MY_INCLUDE_DIR__")"
