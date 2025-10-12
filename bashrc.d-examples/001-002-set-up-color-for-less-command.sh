function __main__() {
    unset -f "$FUNCNAME"

    set_LESS

    true
}

function set_LESS() {
    unset -f "$FUNCNAME"
    export LESS='-R --use-color -Dd+r$Du+b$'
}

__main__