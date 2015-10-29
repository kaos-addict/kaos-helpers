# Enable bash completion
[ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

# Even with sudo command:
complete -cf sudo

# Allow root windows:
xhost +local:root > /dev/null 2>&1

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

# Few environment variables:
export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth
export EDITOR=nano
export VISUAL=nano

# Prompt:
PS1='[\u@\h \W]\$ '

# Source alias file if present:
if [ -f .bash_aliases ]; then source .bash_aliases;fi

# Source functions file if present:
if [ -f .bash_functions ]; then source .bash_functions;fi
