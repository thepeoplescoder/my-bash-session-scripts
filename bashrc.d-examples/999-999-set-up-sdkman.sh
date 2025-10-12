#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!

function __main__() {
    unset -f "$FUNCNAME"

    set_SDKMAN_DIR_and_sdkman_environment

    true
}

function set_SDKMAN_DIR_and_sdkman_environment() {
    unset -f "$FUNCNAME"
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
}

__main__