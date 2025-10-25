# This is just to deliberately cause some commands to slow down for *slightly* easier reading.
function with_post_delay() {
    local exitCode
    "$@"
    exitCode=$?
    sleep $DELAY
    return $exitCode
}
DELAY=0
