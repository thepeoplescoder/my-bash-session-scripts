# alias ls='LC_COLLATE=C ls --group-directories-first --color=auto '
alias ls="$(
    case "$__OS__" in
        linux) echo "LC_COLLATE=C ls --group-directories-first --color=auto" ;;
        *)     echo "LC_COLLATE=C ls --color=always"                         ;;
    esac
)"
alias grep='grep --color=auto '
alias ip='ip -color=auto '
alias diff='diff --color=auto '
