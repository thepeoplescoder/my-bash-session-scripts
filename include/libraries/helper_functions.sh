if [[ -v __HELPER_FUNCTIONS_DOT_SH__ ]]; then
    return 0
fi

unset_on_exit __HELPER_FUNCTIONS_DOT_SH__
__HELPER_FUNCTIONS_DOT_SH__="$(get_this_file_name)"

source "$__MY_INCLUDE_DIR__/libraries/text_io/_.sh"

unset_on_exit is_root_user
function is_root_user() {
    # [ "$1" == "" ] && (( EUID == 0 )) || [[ "$1" == "root" ]]
    if [[ -z "$1" ]]; then
        (( EUID == 0 ))
    else
        [[ "$1" == "root" ]]
    fi
}

unset_on_exit __say_that_we_are__
function __say_that_we_are__() {
    local Action=$1
    local TheThing=$2
    local NormalColor=$3
    local HighlightColor=$4

    if [[ ! "$NormalColor" ]]; then
        NormalColor=$(__theme__ normal)
    fi

    if [[ ! "$HighlightColor" ]]; then
        HighlightColor=$(__theme__ highlight)
    fi

    echo -ne "${NormalColor}${Action} "
    echo -ne "${HighlightColor}${TheThing} "
    echo -ne "${NormalColor}. . ."
    echo -ne "\033[0m"
}

unset_on_exit __add_username_label_if_logged_in_as__
function __add_username_label_if_logged_in_as__() {
    if [ "$USER" == "$1" ]; then
        __ansi__ default
        echo -n "($1) "
    fi
    _indent
}

unset_on_exit __bash_sessionstart_notify__
function __bash_sessionstart_notify__() {
    local x=$2
    if [[ ! "$x" ]]; then
        x="$(__this_file_name__)"
    fi
    __add_username_label_if_logged_in_as__ root
    echo -n "$3"
    __say_that_we_are__ "$1" "$x" "$(__theme__ normal)" "$(__theme__ highlight)"
}

unset_on_exit __say__
function __say__() {
    __add_username_label_if_logged_in_as__ root
    echo -n "$2"
    echo -n "$1"
}

unset_on_exit command_exists
function command_exists() {
    command -v "$@" &> /dev/null
}

unset_on_exit prepend_to_PATH_if_it_exists
function prepend_to_PATH_if_it_exists() {
    [[ -d "$1" ]] && export PATH="$1:$PATH"
}

unset_on_exit get_interpreter_for
function get_interpreter_for() {
    case "$1" in
        *.py) echo "python"   ;;
        *.js) echo "node"     ;;
        *.ts) echo "deno run" ;;
        *.rb) echo "ruby"     ;;
        *.pl) echo "perl"     ;;
    esac
}