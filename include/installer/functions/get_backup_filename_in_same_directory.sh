if declare -f get_backup_filename &> /dev/null; then
    return 0
fi

source "$(dirname "${BASH_SOURCE[0]}")/find_rotation_target.sh"

function get_backup_filename_in_same_directory() {
    local originalFile="$1"
    local directory="$(dirname "$originalFile")"

    pushd "$directory" > /dev/null || return 1
    local backupBasename="$(find_rotation_target "$(basename "$originalFile")" 999)"
    popd > /dev/null || return 1

    echo "$directory/$backupBasename"
}
