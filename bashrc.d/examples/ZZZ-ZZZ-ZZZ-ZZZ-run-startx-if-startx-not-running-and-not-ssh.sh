if [[ ! "$SSH_CONNECTION" && ! "$DISPLAY" && ${XDG_VTNR:-0} -eq 1 ]]; then
	pgrep -x startx &>/dev/null || startx
fi
