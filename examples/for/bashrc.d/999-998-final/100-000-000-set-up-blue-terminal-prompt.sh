unset_on_exit BRACKET_COLOR
unset_on_exit USERNAME_COLOR AT_COLOR HOSTNAME_COLOR
unset_on_exit CURRENT_DIRECTORY_COLOR
unset_on_exit PROMPT_COLOR PROMPT_TERMINATOR
unset_on_exit PS1_RESET_TERMINAL

BRACKET_COLOR=$(__unprintable__ $(__ansi__ bright blue))
USERNAME_COLOR=$(__unprintable__ $(__ansi__ color cyan))
AT_COLOR=$(__unprintable__ $(__ansi__ bright cyan))
HOSTNAME_COLOR=$USERNAME_COLOR
CURRENT_DIRECTORY_COLOR=$(__unprintable__ $(__ansi__ bright white))
PROMPT_COLOR=$BRACKET_COLOR
PS1_RESET_TERMINAL=$(__unprintable__ $(__ansi__ reset))
PROMPT_TERMINATOR='$'

if is_root_user; then
	USERNAME_COLOR="$USERNAME_COLOR$(__unprintable__ $(tput blink))"
fi

# username@host currentWorkingDirectory
PS1="${USERNAME_COLOR}\u${PS1_RESET_TERMINAL}"
PS1="${PS1}${AT_COLOR}@${HOSTNAME_COLOR}\h${PS1_RESET_TERMINAL} "
PS1="${PS1}${CURRENT_DIRECTORY_COLOR}\w"

# [username@host currentWorkingDirectory]
PS1="${BRACKET_COLOR}[${PS1}${BRACKET_COLOR}]"

# [username@host currentWorkingDirectory]$
PS1="${PS1}${PROMPT_COLOR}${PROMPT_TERMINATOR}"
PS1="${PS1}${PS1_RESET_TERMINAL}"

if is_root_user; then
	PS1="${PS1}$(__unprintable__ )"
fi
PS1="${PS1} "