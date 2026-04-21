[ ! -v USERPROFILE ] && return 0

NVM_DIR="$(cygpath "$USERPROFILE")"
NVM_DIR="$NVM_DIR/AppData/Local/nvm"

if [ ! -d "$NVM_DIR" ]; then
	unset NVM_DIR
	return 0
fi

NVM4W_DIR="$(cygpath "C:\\nvm4w")"

if [ ! -d "$NVM4W_DIR" ]; then
	unset NVM_DIR
	unset NVM4W_DIR
	return 0
fi

NODEJS_DIR="$NVM4W_DIR/nodejs"

if [ ! -d "$NODEJS_DIR" ]; then
	unset NVM_DIR
	unset NVM4W_DIR
	unset NODEJS_DIR
	return 0
fi

export PATH="$PATH:$NVM_DIR:$NODEJS_DIR"
export NVM_DIR="$NVM_DIR"

unset NVM4W_DIR
unset NODEJS_DIR

