if [[ -v __INSTALLER_SLASH_TEXT_AND_COLOR_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_TEXT_AND_COLOR_DOT_SH__="$(get_this_file_name)"

for __library__ in \
    "$__MY_INCLUDE_DIR__/libraries/_.sh"
do
    source "$__library__" || ( echo "$__library__ not found." && exit 1 )
done
unset __library__

function __beep__() {
    echo -ne "\\a"
}

function echo_and_reset() {
    echo "$@"
    __ansi__ reset
}

function error_echo() {
    __ansi__ color red
    echo_and_reset "$@"
    false
}

function log_echo() {
    __ansi__ bright green
    echo_and_reset "$@"
}

function log_to_console() {
    local C="$(__ansi__ bright green)"
    local H="$(__ansi__ bright yellow)"
    local x="$3"

    [[ ! "$x" ]] && x="..."

    echo_and_reset -n "${C}$1 ${H}$2${C}$x"
}

function colorize_cp_or_ln() {
    local color1="$(__ansi__ bright red)"
    local arrowColor="$(__ansi__ bright cyan)"
    local color2=$color1

    awk -v color1="$color1"          \
        -v arrowColor="$arrowColor"  \
        -v color2="$color2"          \
        -v reset="$(__ansi__ reset)" \
        '{
            print color1 $1 " " arrowColor $2 " " color2 $3 reset
        }'
}

function colorize_rm() {
    local color1="$(__ansi__ bright red)"
    local color2="$(__ansi__ bright cyan)"

    awk -v color1="$color1"          \
        -v color2="$color2"          \
        -v reset="$(__ansi__ reset)" \
        '{
            print color1 $1 " " color2 $2 reset
        }'
}

function colorize_mv_rename() {
    local renamed="$(__ansi__ bright red)"
    local color1="$(__ansi__ bright cyan)"
    local arrowColor="$(__ansi__ bright yellow)"
    local color2=$color1

    awk -v renamed="$renamed"        \
        -v color1="$color1"          \
        -v arrowColor="$arrowColor"  \
        -v color2="$color2"          \
        -v reset="$(__ansi__ reset)" \
        '{
            print renamed $1 " " color1 $2 " " arrowColor $3 " " color2 $4 reset
        }'
}
