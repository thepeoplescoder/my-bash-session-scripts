if [[ -v __LIBRARIES_SLASH_TEXT_IO_SLASH_COLORS_DOT_SH__ ]]; then
	return 0
fi

unset_on_exit __LIBRARIES_SLASH_TEXT_IO_SLASH_COLORS_DOT_SH__
__LIBRARIES_SLASH_TEXT_IO_SLASH_COLORS_DOT_SH__=$(get_this_file_name)

unset_on_exit __color__
function __color__() {
	local brightness
	if [[ "$1" == "bright" ]]; then
		brightness="1;"
		shift
	else
		brightness="22;"
	fi

	case "$1" in
		black)
			echo "${brightness}30"
			;;
		red)
			echo "${brightness}31"
			;;
		green)
			echo "${brightness}32"
			;;
		yellow)
			echo "${brightness}33"
			;;
		blue)
			echo "${brightness}34"
			;;
		magenta)
			echo "${brightness}35"
			;;
		cyan)
			echo "${brightness}36"
			;;
		white)
			echo "${brightness}37"
			;;
		default)
			echo "${brightness}39"
			;;
		*)
			echo $1
			;;
	esac
}

unset_on_exit __ansi__
function __ansi__() {
	local cmd=$1
	shift
	case "$cmd" in
		color)
			echo -ne "\e[$(__color__ $1)m"
			;;
		fg-256)
			__ansi__ color "38;5;$1"
			;;
		bg-256)
			__ansi__ color "48;5;$1"
			;;
		fg-rgb)
			__ansi__ color "38;2;$1;$2;$3"
			;;
		bg-rgb)
			__ansi__ color "48;2;$1;$2;$3"
			;;
		reset)
			__ansi__ color 0
			;;
		bright)
			__ansi__ color $(__color__ bright $1)
			;;
		*)
			__ansi__ reset
			;;
	esac
}

unset_on_exit __theme__
function __theme__() {
	case "$1" in
		normal)
			__ansi__ bright blue
			;;
		highlight)
			__ansi__ bright yellow
			;;
	esac
}

__ansi__ reset
