if declare -f display_installer_help &> /dev/null; then
    return 0
fi

function display_installer_help() {
    local scriptExecutable="$1"
 
    local skip_a_line="<skip-a-line>"

    # local -a help_entries_display_order=("--help" "--dry-run" "$skip_a_line" "--to")
    local -a help_entries_display_order=("--help" "--dry-run")

    local -A help_entries=(
        ["--help"]='help_entry_dash_dash_help'
        ["--dry-run"]='help_entry_dash_dash_dry_dash_run'
        # ["--to"]='help_entry_dash_dash_to'
    )

    local -a help_entry_dash_dash_help=(
        "Displays this information."
    )
    local -a help_entry_dash_dash_dry_dash_run=(
        "Performs a dry run.  No changes are made to your system."
    )
    # local -a help_entry_dash_dash_to=(
    #     "Specifies the installation location, which is the argument that follows."
    #     "$(__ansi__ bright red)If not provided, this location will default to:"
    #     "    $(__ansi__ bright yellow)$DEFAULT_INSTALL_DIRECTORY$(__ansi__ reset)"
    # )

    local -a parts_of_the_command=(
        "$(__ansi__ bright white)$(basename "$scriptExecutable")"
        "$(__ansi__ bright black)[--help]"
        "$(__ansi__ bright black)[--dry-run]"
        "$(__ansi__ bright black)[--to /path/to/install/location]"
    )

    (IFS=' '; echo "${parts_of_the_command[*]}") && echo

    local cmd
    local i

    _push_indent
        for cmd in "${help_entries_display_order[@]}"; do
            [[ "$cmd" == "$skip_a_line" ]] && echo && continue

            local array_name="${help_entries[$cmd]}"
            local -n lines="$array_name"

            _indent
            printf "$(__ansi__ bright blue)%9s$(__ansi__ bright yellow) - $(__ansi__ bright white)%s$(__ansi__ reset)\n" \
                "$cmd" "${lines[0]}"

            for (( i = 1; i < ${#lines[@]}; i++ )); do
                _indent && printf "%9s   $(__ansi__ bright white)%s$(__ansi__ reset)\n" "" "${lines[i]}"
            done
        done
    _pop_indent

    __ansi__ reset

    true
}
