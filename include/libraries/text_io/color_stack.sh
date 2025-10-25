if [ -v COLOR_STACK ]; then
    return 0
fi

unset_on_exit COLOR_STACK
declare -a COLOR_STACK

source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

unset_on_exit __set_color__
function __set_color__() {
    if [[ "$1" == "" ]]; then
        __ansi__ reset
    else
        __ansi__ color $1
    fi
}
export -f __set_color__

unset_on_exit set_color
function set_color() {
    COLOR_STACK+=("$1")
    __set_color__ $1
}

unset_on_exit peek_color
function peek_color() {
    local colorStackSize=${#COLOR_STACK[@]}
    if [ $colorStackSize -lt 1 ]; then
        echo ""
    else
        local lastIndex=$(( $colorStackSize - 1 ))
        echo "${COLOR_STACK[lastIndex]}"
    fi
}

unset_on_exit pop_color
function pop_color() {
    local colorStackSize=${#COLOR_STACK[@]}
    if [ $colorStackSize -lt 1 ]; then
        __set_color__
    else
        local lastIndex=$(( $colorStackSize - 1 ))
        unset "COLOR_STACK[lastIndex]"
        __set_color__ $(peek_color)
    fi
}
