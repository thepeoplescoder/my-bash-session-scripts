# alias ls='LC_COLLATE=C ls --group-directories-first --color=auto '
command_exists 'ls' && alias ls="$(
    case "$__PLATFORM__" in
        bsd|macos) echo "LC_COLLATE=C ls --color=always" ;;
        *)         echo "LC_COLLATE=C ls --group-directories-first --color=auto" ;;
    esac
)"
command_exists 'grep' && alias grep='grep --color=auto '
command_exists 'ip'   && alias ip='ip -color=auto '
command_exists 'diff' && alias diff='diff --color=auto '

command_exists 'gls' && alias gls="LC_COLLATE=C gls --group-directories-first --color=auto"
