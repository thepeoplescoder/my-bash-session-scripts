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

    local text="$(cat "$optionsFile")"

    if [[ ! "$text" ]]; then
        return 1
    fi

    case "$__OS__" in
        msys2|mingw32|mingw64)
            if [ -v MSYS2 ]; then
                echo "MSYS2 already set to $MSYS2"
            else
                echo "Executing: export MSYS2=\"$text\""
                export MSYS2="$text"
            fi
            ;;
        cygwin)
            if [ -v CYGWIN ]; then
                echo "CYGWIN already set to $CYGWIN"
            else
                echo "Executing: export CYGWIN=\"$text\""
                export CYGWIN="$text"
            fi
            ;;
    esac
}

set_CYGWIN_or_MSYS2_for_windows_operating_systems
