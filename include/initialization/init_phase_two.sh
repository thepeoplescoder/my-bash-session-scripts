if [[ -v __INITIALIZATION_SLASH_INIT_PHASE_TWO_DOT_SH__ ]]; then
	return 0
fi

__INITIALIZATION_SLASH_INIT_PHASE_TWO_DOT_SH__="$(get_this_file_name)"

if [[ ! -v __OS__ ]]; then
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
fi

if [[ ! -v __OS_IS_WINDOWS__ ]]; then
    export __OS_IS_WINDOWS__="$(
        case "$__OS__" in
            cygwin|msys2|mingw32|mingw64) echo "true"  ;;
            *)                            echo "false" ;;
        esac
    )"
fi

function set_CYGWIN_or_MSYS2_for_windows_operating_systems() {
    unset -f "$FUNCNAME"

    local optionsFile="$HOME/.windows_cygwin_msys2_options"
    if ! $__OS_IS_WINDOWS__ || ! [[ -f "$optionsFile" ]]; then
        return 1
    fi

    local var
    case "$__OS__" in
        msys2|mingw32|mingw64) var="MSYS"   ;;
        cygwin)                var="CYGWIN" ;;
        *)                     return 1     ;;
    esac

    if [[ -v $var ]]; then
        __echo_if_not_logout "$var already set to ${!var}"
        return 0
    fi

    local value="$(<"$optionsFile")"
    __echo_if_not_logout "Executing: export $var=\"$value\""
    export "$var=$value"
}

unset_on_exit __echo_if_not_logout
function __echo_if_not_logout() {
    [ -v __MY_BASH_LOGOUT__ ] && return 1
    echo "$@"
}

set_CYGWIN_or_MSYS2_for_windows_operating_systems
