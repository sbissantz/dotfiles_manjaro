#
#
# ~/.bashrc
#
# Note: Configuring the interactive Bash usage, like Bash aliases, setting your
# favorite editor, setting the Bash prompt, etc.
#

# Get rif of the 'cannot connect to X server :0.0' error
#
xhost +local:root > /dev/null 2>&1

# Bash completion (if available)
# 
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# Dotfile management with 'gitconf'
# https://wiki.archlinux.org/index.php/Dotfiles
#

if [ -f /usr/share/bash-complete-alias/complete_alias ]; then
	. /usr/share/bash-complete-alias/complete_alias
	alias gitconf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
	complete -F config _complete_alias
else
	echo "Steven, '/usr/shar/bash-complete-alias/complete_alias' is missing"
fi

# PS1 prompt (with colors).
# References:
# - http://www-128.ibm.com/developerworks/linux/library/l-tip-prompt/
# - http://networking.ringofsaturn.com/Unix/Bash-prompts.php
#
PS1="\[\e[36;1m\]\h:\[\e[32;1m\]\w$ \[\e[0m\]"

# Export
#

# don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth
# Append commands to the history every time a prompt is shown,
# instead of after closing the session.
export PROMPT_COMMAND='history -a'

# Shopt
# https://ss64.com/bash/shopt.html
#

# automatically correct mistyped directory names on cd
shopt -s cdspell
# Include  dotfiles in the results of filename expansion
shopt -s dotglob
# Aliases are expanded
shopt -s expand_aliases
# Enable extended pattern matching features described above 
shopt -s extglob
# Matches filenames in a case-insensitive
shopt -s nocaseglob
# Don't overwrite, append commands to ~/.bash_history
shopt -s histappend

# Bash aliases
#

if [ -f $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

# R alias
#
alias R="R --quiet"
alias R-devel="R-devel --quiet"
