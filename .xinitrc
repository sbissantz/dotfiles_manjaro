#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

DEFAULT_SESSION='i3 --shmlog-size 0'

# merge in defaults and keymaps
#
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Start gnome keyring daemon
# https://wiki.archlinux.org/index.php/GNOME/Keyring
#
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# feh background
#

~/.fehbg &

# Network Manager
#
nm-applet --sm-disable &

# Cursor hiding
#
unclutter --timeout 2 --jitter 50 --ignore-scrolling &

# Touchpad off at startup
#
xinput --disable $(xinput --list | grep -i 'touchpad' | grep -o 'id=[0-9]*' | sed 's/id=//')  &

# urxvtd - urxvt terminal daemon (speed up)
#
urxvtd -q -f -o &

# Dunst fails to start via systemd 
# happens with non-graphical interfaces
# https://wiki.archlinux.org/index.php/Dunst
systemctl --user import-environment DISPLAY

####################
#
# i3wm (last line)
#
exec i3


