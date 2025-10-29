if declare -f with_post_delay &> /dev/null; then
    return 0
fi

# This is just to deliberately cause some commands to slow down for *slightly* easier reading.
unset_on_exit with_post_delay
function with_post_delay() {
    local exitCode
    "$@"
    exitCode=$?
    sleep $__with_post_delay__DELAY
    return $exitCode
}

unset_on_exit __with_post_delay__DELAY
__with_post_delay__DELAY=0
