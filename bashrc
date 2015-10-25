if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

xhost +local:root > /dev/null 2>&1

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth

alias ls='ls --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias grep='grep --color=tty -d skip'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias vp='nano PKGBUILD'
alias vs='nano SPLITBUILD'
alias upd='mirror-check && sudo pacman -Syu'
alias dvdburn='growisofs -Z /dev/sr0 -R -J'

export EDITOR=nano
export VISUAL=nano

# prompt
PS1='[\u@\h \W]\$ '

# Source alias file if present
if [ -f .bash_aliases ]; then source .bash_aliases;fi
# Source functionns file if present
if [ -f .bash_functions ]; then source .bash_functions;fi
