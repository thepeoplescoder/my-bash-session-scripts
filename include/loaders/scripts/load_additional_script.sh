if is_sourceable "$1"; then
    source "$1"

elif is_emittable "$1"; then
    __the_output_emitted_by_the_current_file__=''

    if is_executable "$1"; then
        __the_output_emitted_by_the_current_file__="$("$1")"
    else
        unset_on_exit __the_current_interpreter_for_this_file__
        read -r -a __the_current_interpreter_for_this_file__ <<< "$(get_interpreter_for "$1")"
        command_exists "${__the_current_interpreter_for_this_file__[0]}" || return
        __the_output_emitted_by_the_current_file__="$("${__the_current_interpreter_for_this_file__[@]}" "$1")"
    fi

    [ "$__the_output_emitted_by_the_current_file__" ] || return

    # I'll eventually figure out a way to put this in here so emitters can be examined for malicious statements.
    # tput smcup
    # (
    #     echo "Emitter contents of $1"
    #     echo
    #     echo "$__the_output_emitted_by_the_current_file__"
    # ) | less -XR
    # tput rmcup

    __the_emitter_tag_delimiter__='#!'

    grep -qv "^$__the_emitter_tag_delimiter__" <<< "$__the_output_emitted_by_the_current_file__" && echo

    while IFS= read -r __the_current_output_line_from_the_current_file__; do

        if ! [[ "$__the_current_output_line_from_the_current_file__" == "$__the_emitter_tag_delimiter__"* ]]; then
            echo "$__the_current_output_line_from_the_current_file__"
            continue
        fi

        __the_current_output_line_from_the_current_file__="${__the_current_output_line_from_the_current_file__:${#__the_emitter_tag_delimiter__}}"

        __the_tag_for_the_current_line__="${__the_current_output_line_from_the_current_file__%% *}"
        __the_payload_for_the_current_line__="${__the_current_output_line_from_the_current_file__#"$__the_tag_for_the_current_line__ "}"

        if [[ "$__the_tag_for_the_current_line__" != "$__the_current_output_line_from_the_current_file__" ]]; then
            case "$__the_tag_for_the_current_line__" in
                'emit') eval "${__the_payload_for_the_current_line__}"        ;;
                *)      echo "Unknown tag: $__the_tag_for_the_current_line__" ;;
            esac
        else
            echo "x${__the_tag_for_the_current_line__}x"
        fi

        unset __the_tag_for_the_current_line__
        unset __the_payload_for_the_current_line__

    done <<< "$__the_output_emitted_by_the_current_file__"

    grep -qv "^$__the_emitter_tag_delimiter__" <<< "$__the_output_emitted_by_the_current_file__" && echo

    unset __the_emitter_tag_delimiter__
    unset __the_output_emitted_by_the_current_file__
fi