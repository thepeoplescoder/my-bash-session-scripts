	unset -f "$FUNCNAME"

	if [ ! -v SOURCED_FILE_STACK ]; then
		unset_on_exit SOURCED_FILE_STACK
		declare -a SOURCED_FILE_STACK

		unset_on_exit __enter_this_file__
		function __enter_this_file__() {
			# Ensure we have at least 3 elements: [0]this_func, [1]caller_func, [2]file_name
			if [ ${#BASH_SOURCE[@]} -lt 3 ]; then
				return 1	# Cannot determine file path
			fi
			thisFileName="${BASH_SOURCE[1]/#$HOME/\~}"
			SOURCED_FILE_STACK+=("$thisFileName")
		}

		unset_on_exit __leave_this_file__
		function __leave_this_file__() {
			sourcedFileStackSize=${#SOURCED_FILE_STACK[@]}
			if [ $sourcedFileStackSize -lt 1 ]; then
				return
			fi

			lastIndexOfStack=$(( $sourcedFileStackSize - 1 ))
			unset "SOURCED_FILE_STACK[lastIndexOfStack]"
		}

		unset_on_exit __this_file_name__
		function __this_file_name__() {
			sourcedFileStackSize=${#SOURCED_FILE_STACK[@]}
			if [ $sourcedFileStackSize -lt 1 ]; then
				echo "<empty>"
			else
				lastIndexOfStack=$(( $sourcedFileStackSize - 1 ))
				echo "${SOURCED_FILE_STACK[lastIndexOfStack]}"
			fi
		}
	fi
