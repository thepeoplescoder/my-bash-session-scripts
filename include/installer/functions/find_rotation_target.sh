if declare -f find_rotation_target &> /dev/null; then
    return 0
fi

# Function to find the next available filename for rotation
# Usage: find_rotation_target <base_name> <max_index>
# Returns: The chosen filename (or an empty string on fatal error)
unset_on_exit find_rotation_target
function find_rotation_target() {
    # 1. Ensure variables inside this function are local to it
    local BASE_NAME="$1"
    local MAX_INDEX="$2"
    local currentFile=""
    local TARGET_FILE=""
    local i

    # --- Part 1: Find the first non-existing file ---
    for i in $(seq -w 0 "$MAX_INDEX"); do
        currentFile="${BASE_NAME}.${i}.old"
        if [[ ! -f "$currentFile" ]]; then
            TARGET_FILE="$currentFile"
            break
        fi
    done

    # --- Part 2: If TARGET_FILE is empty, find the oldest file ---
    if [[ ! "$TARGET_FILE" ]]; then
        
        # Use find to get the oldest file based on modification time
        TARGET_FILE=$(find . \
            -maxdepth 1 \
            -type f \
            -name "${BASE_NAME}.???.old" \
            -printf '%T@ %p\n' |
            sort -n |
            head -n 1 |
            awk '{print $2}')
    fi

    # Print the result to stdout so the calling script can capture it
    echo "$TARGET_FILE"
}
