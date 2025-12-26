! command_exists 'sed' && return 0

function_template=$(
cat <<'SHELL'
function mount() {
    if [ $# -lt 1 ]; then
        local no_space_capture='\([^ ]*\)'
        local capture_everything='\(.*\)'

        local pattern="^${no_space_capture} on ${no_space_capture} type ${no_space_capture} ${capture_everything}\$"

        local replace=''
        replace="${replace}{__DEVICE__}\\1{__RESET__}"
        replace="${replace} on {__MOUNT_POINT__}\\2{__RESET__}"
        replace="${replace} type {__TYPE__}\\3{__RESET__}"
        replace="${replace} {__OPTIONS__}\\4{__RESET__}"
        
        command mount | sed -e "s/$pattern/$replace/"
    else
        command mount "$@"
    fi
}
SHELL
)

function_body=$function_template
function_body=${function_body//'{__RESET__}'/"$(__ansi__ reset)"}
function_body=${function_body//'{__DEVICE__}'/'\x1b[1m'"$(__ansi__ bright green)"}
function_body=${function_body//'{__MOUNT_POINT__}'/"$(__ansi__ color cyan)"}
function_body=${function_body//'{__TYPE__}'/"$(__ansi__ bright yellow)"}
function_body=${function_body//'{__OPTIONS__}'/"$(__ansi__ bright black)"}

eval "$function_body"

unset function_template function_body