source "$__MY_INCLUDE_DIR__/aliases/_.sh"

! command_exists 'sed' && return 0

function_template=$(
cat <<'SHELL'
function alias() {
    if [ $# -lt 1 ]; then
        local pattern='^\(alias\)[[:space:]]\+\([^=]*\)=\(.*\)$'
        local replace='\1 {__COLOR1__}\2{__RESET__}={__COLOR2__}\3{__RESET__}'
        builtin alias | sed -e "s/$pattern/$replace/"
    else
        builtin alias "$@"
    fi
}
SHELL
)

function_body=$function_template
function_body=${function_body//'{__RESET__}'/"$(__ansi__ reset)"}
function_body=${function_body//'{__COLOR1__}'/'\x1b[1m'"$(__ansi__ bright green)"}
function_body=${function_body//'{__COLOR2__}'/"$(__ansi__ color cyan)"}

eval "$function_body"

unset function_template function_body