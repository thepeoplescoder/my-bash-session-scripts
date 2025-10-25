# The following self-deleting function doubles as our include guard.
if declare -f on_exit &> /dev/null; then
	return 0
fi

function on_exit() {
	[[ ! "${FUNCNAME[1]}" ]] && echo "This function must be called from the top level." && return 1

	local basenameOfCaller="$(basename "${BASH_SOURCE[1]}")"

	! [[ "$basenameOfCaller" == ".bash_profile" || "$basenameOfCaller" == ".bashrc" ]] \
		&& echo "This function can only be called from .bash_profile or .bashrc."      \
		&& return 1

	__on_exit__NUMBER_OF_CALLS=$(( $__on_exit__NUMBER_OF_CALLS + 1 ))

	[[ -v __MY_DOT_BASH_PROFILE__ && __on_exit__NUMBER_OF_CALLS -lt 2 ]] && return

	unset -f "$FUNCNAME"
	__run_cleanup__ &> /dev/null
	echo

	unset __on_exit__NUMBER_OF_CALLS
	true
}
__on_exit__NUMBER_OF_CALLS=0

###########################################################

__run_cleanup___VARIABLES_TO_UNSET__=()

function __run_cleanup__() {
	unset -f "$FUNCNAME"

	local name
	for name in "${__run_cleanup___VARIABLES_TO_UNSET__[@]}"; do
		unset -f "$name" 2>/dev/null
		unset    "$name" 2>/dev/null
	done

	__run_cleanup___VARIABLES_TO_UNSET__=()
	unset __run_cleanup___VARIABLES_TO_UNSET__
}

###########################################################

function unset_on_exit() {
	local name
	for name in "$@"; do
		__run_cleanup___VARIABLES_TO_UNSET__+=("$name")
	done
}

###########################################################

unset_on_exit unset_on_exit