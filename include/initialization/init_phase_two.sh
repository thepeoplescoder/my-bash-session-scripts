if [[ -v __OS__ && -v __OS_IS_WINDOWS__ ]]; then
    return 0
fi

export __OS__="$(
	case "$(uname -s)" in
		Linux)          echo "linux"     ;;
		*BSD|DragonFly) echo "bsd"       ;;
		Darwin)         echo "macos"     ;;
		CYGWIN*)        echo "cygwin"    ;;
		MSYS*)          echo "msys2"     ;;
		MINGW32*)       echo "mingw32"   ;;
		MINGW64*)       echo "mingw64"   ;;
		*)              echo "<unknown>" ;;
	esac
)"

export __OS_IS_WINDOWS__="$(
	case "$__OS__" in
		cygwin|msys2|mingw32|mingw64) echo "true"  ;;
		*)                            echo "false" ;;
	esac
)"

function set_up_symlinks_for_windows_operating_systems() {
    unset -f "$FUNCNAME"

    local symlinkFileName="$HOME/.windows_cygwin_msys2_options"

    if ! $__OS_IS_WINDOWS__ || ! [[ -f "$symlinkFileName" ]]; then
        return 1
    fi

    local windowsSymlinks="$(cat "$symlinkFileName")"

    if [[ ! "$windowsSymlinks" ]]; then
        return 1
    fi

    echo -n "Enabling native Windows symlinks via: "
    case "$__OS__" in
        msys2|mingw32|mingw64) 
            echo "export MSYS2=\"$windowsSymlinks\""
            export MSYS2="$windowsSymlinks"
            ;;
        cygwin)
            echo "export CYGWIN=\"$windowsSymlinks\""
            export CYGWIN="$windowsSymlinks"
            ;;
    esac
}

set_up_symlinks_for_windows_operating_systems
