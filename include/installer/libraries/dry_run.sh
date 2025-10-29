if [[ -v __INSTALLER_SLASH_LIBRARIES_SLASH_DRY_RUN_DOT_SH__ ]]; then
    return 0
fi

__INSTALLER_SLASH_LIBRARIES_SLASH_DRY_RUN_DOT_SH__="$(get_this_file_name)"

function dry_echo() {
    local msg="$1"

    ! is_dry_run && return 1

    __ansi__ reset    
    echo "[DRY RUN]: $msg"
}
__print_dry_run_message__=0

function enable_dry_run() {
    __print_dry_run_message__=1
}

function is_dry_run() {
    (( __print_dry_run_message__ != 0))
}