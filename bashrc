# Enable bash completion
[ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

# Allow root windows:
xhost +local:root > /dev/null 2>&1

# Complete even sudo commands:
complete -cf sudo

# Some shell options:
shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

# Few environment variables (edit to your preferences):
export HISTSIZE=10000		# Nb of lines in history
export HISTFILESIZE=${HISTSIZE}	# Limit also history filesize
export HISTCONTROL=ignoreboth	# 
export EDITOR=nano		# Some scripts and applications use this as default terminal text editor
export VISUAL=nano		# "
export XEDITOR=kate		# Added a X version

# Prompt:
PS1='[\u@\h \W]\$ '

# Source alias file if present:
if [ -f .bash_aliases ]; then source .bash_aliases;fi

# Source functions file if present:
if [ -f .bash_functions ]; then source .bash_functions;fi
