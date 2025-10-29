if [[ -v __LOADERS_SLASH_ENVIRONMENT_VARIABLES_SLASH_INITIAL_DOT_SH__ ]]; then
    return 0
fi

unset_on_exit __LOADERS_SLASH_ENVIRONMENT_VARIABLES_SLASH_INITIAL_DOT_SH__
__LOADERS_SLASH_ENVIRONMENT_VARIABLES_SLASH_INITIAL_DOT_SH__="$(get_this_file_name)"
    
STARTING_SCRIPTS=("aliases" "functions")    # These get loaded first.
ADDITIONAL_SCRIPTS_DIRECTORY="bashrc.d"     # Then any script in this directory gets loaded.
ENDING_SCRIPTS=("terminal_prompt")          # Finally, these scripts are loaded.

SOURCEABLE_EXTENSIONS=("sh" "bash")
EMITTABLE_EXTENSIONS=("py" "js" "ts" "pl" "rb")

unset_on_exit STARTING_SCRIPTS
unset_on_exit ADDITIONAL_SCRIPTS_DIRECTORY
unset_on_exit ENDING_SCRIPTS

unset_on_exit SOURCEABLE_EXTENSIONS
unset_on_exit EMITTABLE_EXTENSIONS
