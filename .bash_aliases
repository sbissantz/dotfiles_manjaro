# Overwrite/delete warnings
#
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias cp='cp -i'

# (Colored) ls
#
alias l='ls -F --color=auto'
alias ls='ls -F'
alias ll='ls -lhF --color=auto'
alias la='ls -alhF --color=auto'

# cd
#
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'

# (Colored) grep
#
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# clear
#
alias c='clear'

# tar
#
alias untar='tar -zxvf'
alias tarit='tar -zcvf'

# wget 
#
alias wget='wget -c '


# R
#
alias R="R --quiet"
alias R-devel="R-devel --quiet"

# IP
#

# external ip
alias ipe='curl ipinfo.io/ip'

# local ip
alias ipi='ipconfig getifaddr en0'

# ping
#
alias ping='ping -c 5'
