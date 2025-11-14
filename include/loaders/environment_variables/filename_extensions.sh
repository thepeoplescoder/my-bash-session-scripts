if [[ ! -v __MY_INCLUDE_DIR__ ]]; then
	echo "__MY_INCLUDE_DIR__ must be defined before sourcing this file."
	exit 1
fi

if [[ -v SOURCEABLE_EXTENSIONS && -v EMITTABLE_EXTENSIONS ]]; then
    return 0
fi

unset_on_exit SOURCEABLE_EXTENSIONS
unset_on_exit EMITTABLE_EXTENSIONS

SOURCEABLE_EXTENSIONS=()
EMITTABLE_EXTENSIONS=()

function generate_SOURCEABLE_EXTENSIONS_and_EMITTABLE_EXTENSIONS() {
    unset -f "$FUNCNAME"

    local file directory="$(dirname "$__MY_INCLUDE_DIR__")/extensions-to-runners"

    for file in "$directory"/*; do
        local extension="$( basename "$file" )"; [[ "$extension" == .* ]] && continue
        local runner="$(    cat      "$file" )"

        if [[ ! "$runner" ]]; then
            echo "Error: no runner for extension $extension"
            continue
        fi

        local -n array="$( [[ "$runner" =~ ^(source|\.)$ ]] && echo "SOURCEABLE" || echo "EMITTABLE" )"_EXTENSIONS

        array+=("$extension")
    done
}

generate_SOURCEABLE_EXTENSIONS_and_EMITTABLE_EXTENSIONS