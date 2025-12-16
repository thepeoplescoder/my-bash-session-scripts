# alias ls='LC_COLLATE=C ls --group-directories-first --color=auto '
alias ls="$(
    case "$__PLATFORM__" in
        bsd|macos) echo "LC_COLLATE=C ls --color=always" ;;
        *)         echo "LC_COLLATE=C ls --group-directories-first --color=auto" ;;
    esac
)"
alias grep='grep --color=auto '
alias ip='ip -color=auto '
alias diff='diff --color=auto '

command_exists 'gls' && alias gls="LC_COLLATE=C gls --group-directories-first --color=auto"
