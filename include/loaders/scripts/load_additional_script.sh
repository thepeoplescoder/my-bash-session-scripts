if is_sourceable "$1"; then
    source "$1"

elif is_emittable "$1"; then
    # __the_current_files_stdout_contents_after_running_it_as_a_process__=''

    # if is_executable "$1"; then
    #     __the_current_files_stdout_contents_after_running_it_as_a_process__="$(
    #         "$1"
    #     )"
    # else
    #     unset_on_exit __the_current_interpreter_for_this_file__
    #     read -r -a __the_current_interpreter_for_this_file__ <<< "$(get_interpreter_for "$1")"
    #     command_exists "${__the_current_interpreter_for_this_file__[0]}" || return
        
    #     __the_current_files_stdout_contents_after_running_it_as_a_process__="$(
    #         "${__the_current_interpreter_for_this_file__[@]}" "$1"
    #     )"
    # fi

    __the_current_files_stdout_contents_after_running_it_as_a_process__="$(
        if is_executable "$1"; then
            "$1"
        else
            read -r -a __the_current_interpreter_for_this_file__ <<< "$(get_interpreter_for "$1")"
            command_exists "${__the_current_interpreter_for_this_file__[0]}" || exit 1
            "${__the_current_interpreter_for_this_file__[@]}" "$1"
        fi
    )"

    [ "$__the_current_files_stdout_contents_after_running_it_as_a_process__" ] || return

    # I'll eventually figure out a way to put this in here so emitters can be examined for malicious statements.
    # tput smcup
    # (
    #     echo "Emitter contents of $1"
    #     echo
    #     echo "$__the_current_files_stdout_contents_after_running_it_as_a_process__"
    # ) | less -XR
    # tput rmcup

    __the_emitter_tag_delimiter__='#!'

    function does_this_have_zero_tags() {
        unset -f "$FUNCNAME"
        grep -qv "^$__the_emitter_tag_delimiter__" <<< "$1"
    }

    does_this_have_zero_tags "$__the_current_files_stdout_contents_after_running_it_as_a_process__"
    __the_emitter_output_is_guaranteed_to_be_visible__=$(( $? == 0 ))

    (( __the_emitter_output_is_guaranteed_to_be_visible__ )) && echo

    while IFS= read -r __the_current_output_line_from_the_current_file__; do

        if [[ "$__the_current_output_line_from_the_current_file__" != "$__the_emitter_tag_delimiter__"* ]]; then
            echo "$__the_current_output_line_from_the_current_file__"
            continue
        fi

        __the_current_output_line_from_the_current_file_without_tag_delimiter="$(
            emitter_tag_delimiter_length=${#__the_emitter_tag_delimiter__}
            echo "${__the_current_output_line_from_the_current_file:$emitter_tag_delimiter_length}"
        )"

        __the_tag_name_for_the_current_line__="${__the_current_output_line_from_the_current_file_without_tag_delimiter__%% *}"

        __the_payload_for_the_current_line__="$(
            currentLine="$__the_current_output_line_from_the_current_file_without_tag_delimiter"
            tagName="$__the_tag_name_for_the_current_line__"
            echo "${currentLine#"$tagName"}"
        )"

        if [[
            "$__the_current_output_line_from_the_current_file_without_tag_delimiter__" == "$__the_tag_name_for_the_current_line__"
        ]]; then
            continue
        fi

        case "$__the_tag_name_for_the_current_line__" in
            'emit') eval "${__the_payload_for_the_current_line__}"        ;;
            *)      echo "$(__ansi__ bright red)Unknown tag: $(__ansi__ reset)$__the_tag_name_for_the_current_line__" ;;
        esac

    done <<< "$__the_current_files_stdout_contents_after_running_it_as_a_process__"

    unset __the_tag_name_for_the_current_line__
    unset __the_payload_for_the_current_line__

    (( __the_emitter_output_is_guaranteed_to_be_visible__ )) && echo

    unset __the_emitter_tag_delimiter__
    unset __the_current_files_stdout_contents_after_running_it_as_a_process__
    unset __the_emitter_output_is_guaranteed_to_be_visible__
fi