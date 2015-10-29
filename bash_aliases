### Taken back from bashrc kaos defaults
alias grep='grep --color=tty -d skip'		# Make coloured grep
alias cp="cp -i"		# confirm before overwriting something
alias df='df -h'		# human-readable sizes
alias free='free -m'		# show sizes in MB
alias np='nano PKGBUILD'		# edit PKGBUILD file
alias ns='nano SPLITBUILD'		# edit SPLITBUILD file
alias upd='mirror-check && sudo pacman -Syu'		# System update
alias dvdburn='growisofs -Z /dev/sr0 -R -J'		# Burn cd/dvd
###

# Directory listing and better ls commands
alias ldir="ls -l | egrep '^d'"
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'

# Encrypt/decrypt file with ssl
alias encod="openssl aes-256-cbc -e -a -salt -in $@"
alias decod="openssl aes-256-cbc -d -a -salt -in $@"

# Forget sudo? Re-run last command as root
alias redo='\sudo !!'

# Cp like with progress
alias cpr="rsync --partial --progress --append"

# Rm like with progress
alias rmv="rsync --partial --progress --append --remove-sent-files"

# Show me my ssh public keys
alias ssh-showkeys="tail +1 ~/.ssh/*.pub"

# Display aliases file
alias shalias='cgrep ~/.bash_aliases && alias'

# Display functions file
alias shfunct='cgrep ~/.bash_functions'

# List top ten largest files/directories in current directory
alias ducks='du -cks *|sort -rn|head -11'

##TODO: what's best of these two:

# Clean comments and empty lines:
alias cleancom="sed -i 's/#.*$//;/^$/d'

# Get off comments
alias cgrep="grep -E -v '^(#|$|;)'"

### Kaos-only: 

# Zenity replacement:
alias zenity="qarma"
