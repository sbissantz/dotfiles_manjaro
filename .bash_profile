#
# ~/.bash_profile
# 
# Note: making sure that all the things are loaded for login shells. 
#

# Make sure ~/.profile is loaded
#
if [ -f $HOME/.profile ]; then
	. $HOME/.profile 
else
	echo "Steven, ~/.profile is missing"
	sleep 2
fi

# Make sure ~/.bashrc is loaded
#
if [ -f $HOME/.bashrc ]; then
	. $HOME/.bashrc 
else
	echo "Steven, ~/.bashrc is missing"
	sleep 2
fi

# Autostart X at login
#
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx
fi

# Enable gnome-keyring for applications run through the terminal, such as SSH
# https://wiki.archlinux.org/index.php/GNOME/Keyring 
#

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi

if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
