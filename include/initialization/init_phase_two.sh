if [[ -v __INITIALIZATION_SLASH_INIT_PHASE_TWO_DOT_SH__ ]]; then
	return 0
fi

__INITIALIZATION_SLASH_INIT_PHASE_TWO_DOT_SH__="$(get_this_file_name)"

if [ ! -v __PLATFORM__ ]; then
    export __PLATFORM__="$(
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

if [ ! -v __PLATFORM_IS_WINDOWS__ ]; then
    export __PLATFORM_IS_WINDOWS__="$(
        case "$__PLATFORM__" in
            cygwin|msys2|mingw32|mingw64) echo "true"  ;;
            *)                            echo "false" ;;
        esac
    )"
fi

function set_CYGWIN_or_MSYS2_for_windows_operating_systems() {
    unset -f "$FUNCNAME"

    ! $__PLATFORM_IS_WINDOWS__ && return 1

    local var
    case "$__PLATFORM__" in
        cygwin) var="CYGWIN" ;;
        *)      var="MSYS"   ;;
    esac

    if [ -v "$var" ]; then
        return 0
    fi

    local -a validOptionsFileNames=(
        "$HOME/.windows_cygwin_msys2_options"
        "$HOME/.windows_cygwin_msys2_env"
    )

    local optionsFile
    for optionsFile in "${validOptionsFileNames[@]}"; do
        [[ -f "$optionsFile" ]] && break
        optionsFile=''
    done

    [ ! "$optionsFile" ] && return 1

    local contentsOfOptionsFile="$(<"$optionsFile")"

    export "$var=$contentsOfOptionsFile"
    __echo_if_not_logout "$var is now $contentsOfOptionsFile"
}

unset_on_exit __echo_if_not_logout
function __echo_if_not_logout() {
    [ -v __MY_BASH_LOGOUT__ ] && return 1
    echo "$@"
}

set_CYGWIN_or_MSYS2_for_windows_operating_systems
