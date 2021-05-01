#!/bin/bash

#/etc/acpi/ibm.touchpad.sh

# XAUTHORITY value from 'echo $XAUTHORITY'
export XAUTHORITY="/home/steven/.Xauthority"
export DISPLAY=":`ls -1 /tmp/.X11-unix/ | sed -e s/^X//g | head -n 1`"

# 'Synaptics' is the name of the touchpad manufacterer for ThinkPads (as of writing)
read TPdevice <<EOF
< $( xinput | sed -nre '/Synaptics/s/.*id=([0-9]*).*/\1/p' )
state=$( xinput list-props "$TPdevice" | grep "Device Enabled" | grep -o "[01]$" )

# Check the state of the device and enable/disable accordingly
if [ "$state" -eq '1' ];then
  xinput --disable "$TPdevice"
else
  xinput --enable "$TPdevice"
fi
