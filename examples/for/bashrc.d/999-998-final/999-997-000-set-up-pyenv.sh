$__PLATFORM_IS_WINDOWS__ && return 1

is_wsl && export PATH="$(
	printf "%s\n" "$PATH" |
		tr ':' '\n' |
		grep -vE "^/(mnt|media)/.+/[uU][sS][eE][rR][sS]/.+/[pP][yY][eE][nN][vV]-[wW][iI][nN](/|$)" |
		paste -sd ':' -
)"

unset_on_exit __pyenv_found
function __pyenv_found() {
	command -v pyenv 1>/dev/null 2>&1
}

unset_on_exit which_pyenv_found
function __which_pyenv_found() {
	if __pyenv_found; then
		if "$(command -v pyenv)" help 2>&1 | grep -qiF "github.com/pyenv-win/"; then
			echo "<PYENV-WIN>"
		else
			echo "$p"
		fi
	else
		echo "<NONE>"
	fi
}

case "$(__which_pyenv_found)" in
	"<PYENV-WIN>")
		function pyenv() {
			echo "It was detected that pyenv-win's pyenv is the default pyenv in your PATH."
			echo "Please fix your PATH in a prior section, and ensure you have pyenv installed"
			echo "if you wish to use it."
		}
		return 1
		;;
	"<NONE>")
		PYENV_ROOT="$HOME/.pyenv"
		prepend_to_PATH_if_it_exists "$PYENV_ROOT/bin"
		;;
	*)
		PYENV_ROOT=''
		;;
esac

if ! command_exists 'pyenv'; then
	unset PYENV_ROOT
	return 1
fi

eval "$(pyenv init - bash)"

[[ ! "$PYENV_ROOT" ]] && PYENV_ROOT="$(pyenv root)"
export PYENV_ROOT
