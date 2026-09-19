tf="/usr/share/doc/pkgfile/command-not-found.bash"
pacman -Q pkgfile &> /dev/null && [ -f "$tf" ] && source "$tf"
unset tf
