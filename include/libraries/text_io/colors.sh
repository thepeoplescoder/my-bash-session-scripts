if [[ -v __LIBRARIES_SLASH_TEXT_IO_SLASH_COLORS_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_SLASH_TEXT_IO_SLASH_COLORS_DOT_SH__
__LIBRARIES_SLASH_TEXT_IO_SLASH_COLORS_DOT_SH__=$(get_this_file_name)

unset_on_exit __color__
function __color__() {
	local brightness=''

	case "$1" in
		bright) brightness="1;"  && shift ;;
		*)      brightness="22;"          ;;
	esac

	case "$1" in
		black)   echo "${brightness}30" ;;
		red)     echo "${brightness}31" ;;
		green)   echo "${brightness}32" ;;
		yellow)  echo "${brightness}33" ;;
		blue)    echo "${brightness}34" ;;
		magenta) echo "${brightness}35" ;;
		cyan)    echo "${brightness}36" ;;
		white)   echo "${brightness}37" ;;
		default) echo "${brightness}39" ;;
		*)       echo $1                ;;
	esac
}

unset_on_exit __ansi__
function __ansi__() {
	local cmd=$1
	shift
	case "$cmd" in

		# Colors
		color)  echo -ne "\e[$(__color__ $1)m"        ;;
		fg-256) __ansi__ color "38;5;$1"              ;;
		bg-256) __ansi__ color "48;5;$1"              ;;
		fg-rgb) __ansi__ color "38;2;$1;$2;$3"        ;;
		bg-rgb) __ansi__ color "48;2;$1;$2;$3"        ;;
		reset)  __ansi__ color 0                      ;;
		bright) __ansi__ color $(__color__ bright $1) ;;

		# Text effects
		bold)      echo -ne "\e[1m" ;;
		underline) echo -ne "\e[4m" ;;

		# Screen clearing
		clear)            echo -ne "\e[2J\e[H" ;;
		scrollback-clear) echo -ne "\e[3J"     ;;
		region-clear)
			echo -ne "\e[${1};${2}r"
			__ansi__ locate "$3" "$4"
			;;

		# Cursor manipulation
		locate)         echo -ne "\e[${1};${2}H" ;;
		save-cursor)    echo -ne "\e[s"          ;;
		restore-cursor) echo -ne "\e[u"          ;;
		hide-cursor)    echo -ne "\e[?25l"       ;;
		show-cursor)    echo -ne "\e[?25h"       ;;

		draw-box)
			local x=$1 y=$2 w=$3 h=$4
			local horiz='─' vert='│' tl='┌' tr='┐' bl='└' br='┘'

			__ansi__ save-cursor

			__ansi__ locate $y $x; echo -n "$tl$(printf "$horiz%.0s" $(seq 1 $((w-2))))$tr"

			for i in $(seq 1 $((h-2))); do
				__ansi__ locate $((y+i)) $x; echo -n "$vert"
				__ansi__ locate $((y+i)) $((x+w-1)); echo -n "$vert"
			done

			__ansi__ locate $((y+h-1)) $x; echo -n "$bl$(printf "$horiz%.0s" $(seq 1 $((w-2))))$br"

			__ansi__ restore-cursor
			;;

		flash)
			__ansi__ save-cursor
			__ansi__ locate $1 $2
			__theme__ highlight
			echo -n "$3"
			sleep 0.1
			__ansi__ reset
			__ansi__ restore-cursor
			;;

		*)
			__ansi__ reset
			;;
	esac
}

unset_on_exit __theme__
function __theme__() {
	case "$1" in
		normal)    __ansi__ bright blue   ;;
		highlight) __ansi__ bright yellow ;;
	esac
}

__ansi__ reset
