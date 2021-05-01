# 
#  ~/.profile 
#
# Note: For things that are not specifically related to Bash, like environment
# variables PATH and friends, and should be available anytime.  For example,
# .profile should also be loaded when starting a graphical desktop session.
# 

# Note: Expand the default path with '$PATH:' do not overwrite it!

# Editors
#
export EDITOR="nvim"
export ALTERNATE_EDITOR="vi"
export TERM="urxvt"

# Browser
#
export BROWSER=/usr/bin/firefox

# LaTex
#
export PATH=$PATH:/opt/texlive/2021/bin/x86_64-linux
export MANPATH=$MANPATH:/opt/texlive/2021/texmf-dist/doc/man
export INFOPATH=$INFOPATH:/opt/texlive/2021/texmf-dist/doc/info

# R
#
export R_ENVIRON_USER=$HOME/.R/Renviron

# Additional
#
export QT_QPA_PLATFORMTHEME="qt5ct"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
