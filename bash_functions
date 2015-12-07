### Terminal:
# Add folder to path if not already exported
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# Example: add ~/bin to user path
if [ -d $HOME/bin ];then pathadd $HOME/bin;fi

# Make copy with .ori backup
cpb() { cp $@{,.ori} ;}

# Notify on command end
notime(){
($* ; notify-send "Command over" "$*")
}

### Text
# Find text in any file (find grep)
    fgr() {
    find . -name "${2:-*}" | xargs grep -l "$1"
}

# Replace a text in all given files
replace () {
    perl -e '$a=shift;$b=shift;while($f=shift){open(F,$f);@t=<F>;close(F);\
    map s/$a/$b/,@t;open(W,">$f");print W @t;close(W)}' "$@"
}

### Utilities
# Extract any archive file
ex() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)  tar xf $1      ;;
            *.tar.gz)   tar xf $1      ;;
            *.bz2)      bunzip2 $1      ;;
            *.rar)      rar x $1        ;;
            *.gz)       gunzip $1       ;;
            *.tar)      tar xf $1       ;;
            *.tbz2)     tar xf $1      ;;
            *.tgz)      tar xf $1      ;;
            *.zip)      unzip $1        ;;
            *.Z)        uncompress $1   ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Delete missing files of a m3u playlist
purgem3u() {
  for m3u in "$@"; do
  local tmp=$(mktemp)
  echo $tmp $m3u
  while read f
    do
      [ -f "$f" ] && echo "$f"
    done < "$m3u" > $tmp
    mv $tmp $m3u
  done
}
### :Terminal

### Network:
# Copy directory over ssh as: pussh Myfolder ~/Myremotefolder example.com
pussh(){
    tar czf - "${1}" | ssh @${3} tar xzf - -C ${2}
}

# Create ssh tunnel as: createTunnel user host.com localport remoteport 
createTunnel() {
  if [ $# -eq 3 ]
  then
    user=$1
    host=$2
    localPort=$3
    remotePort=$3
  else
    if [ $# -eq 4 ]
    then
      user=$1
      host=$2
      localPort=$3
      remotePort=$4
    else
      echo -n "User: "; read user
      echo -n "host: "; read host
      echo -n "Distant host: "; read remotePort
      echo -n "Local port: "; read localPort
    fi
  fi
  ssh -N -f $user@$host -L ${localPort}:${host}:${remotePort}
}

#  Ping a host until it responds, then play a sound, then exit (need espeak)
speakwhenup() { 
[ "$1" ] && PHOST="$1" || return 1
until ping -c1 -W2 $PHOST >/dev/null 2>&1 
do 
  sleep 5s 
done
espeak "$PHOST is up" >/dev/null 2>&1
}
### :Network

### Man pages:
# Search
mans () {
    man $1 | grep -iC2 --color=always $2 | less
}

# Needs qarma (Qt zenity like)
qman () {
    man $1 | qarma --text-info --title="Man Page" --width=800 --height=800
}


man() {
	env \
	LESS_TERMCAP_mb=$(printf "\e[1;34m") \
	LESS_TERMCAP_md=$(printf "\e[1;34m") \
	LESS_TERMCAP_me=$(printf "\e[0m") \
	LESS_TERMCAP_se=$(printf "\e[0m") \
	LESS_TERMCAP_so=$(printf "\e[1;30m") \
	LESS_TERMCAP_ue=$(printf "\e[0m") \
	LESS_TERMCAP_us=$(printf "\e[1;36m") \
	man "$@"
}
### :Man Pages

### Various Helpers:
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}
### :Various Helpers

### Administration:
# Journald display helper
yournal() {
journalctl "${@}" | yad --text-info \
--height 700 --width 600 \
--image-path=/usr/share/icons/hicolor/16x16/apps \
--window-icon=kdeapp --image=kaos --title=KalOg \
--center --button=Close --wrap --tail --show-uri
}

### Limit memory usage of one process (needs qarma/zenity)
# Use first argument as the process to limit 
# Optionaly add second arg the memory limit or default is 500M
LimiT() {
NAME=${1}			# Process name to check out
MEM_LIM=500000		# Memory limit, in Ko
MEM_LIM=${2}		# If no limit specified

while [ 1 = 1 ]
do
   PROCESS=$(pgrep -c $NAME); # count processes
   [[ ${PROCESS} -ne 0 ]] && {

	  # get mem (in KB) of process 'NAME'
	  VALMEM=`ps -e orss,comm | grep $NAME | cut -d ' ' -f 1`

	  if [ $VALMEM -gt $MEM_LIM ]
	  then
		 qarma --question --text "$NAME reaches $VALMEM KB" --ok-label "Kill $NAME" --cancel-label "Remember later"
		 RETOUR="$?"; # annuler = 1   ;   valider = 0
			if [ $RETOUR = 0 ]
			then
			   kill -9 `pgrep $NAME`;
			   qarma --info --text "$NAME successfully killed"
			   exit 0
			fi
	  fi
   }
   sleep 30
done
exit 0
}

### Kaos-only:

# Create new kcp package basics need pkgname as argument:
mkpkg() {
    [ -z "$1" ] || [ -d "$1" ] && return 1
    mkdir -p $1 && cd $1 && pckcp -gc && sed -i "s/kaos-pkgbuild-proto/${1}/g" PKGBUILD
    echo -e "# $1\n" > README.md
    kate -n README.md PKGBUILD &
    return 0;
}

# Journald display helper
# yournal() {
# journalctl "${@}" | yad --text-info \
# --height 700 --width 600 \
# --image-path=/usr/share/icons/hicolor/16x16/apps \
# --window-icon=kdeapp --image=kaos --title=KalOg \
# --center --button=Close --wrap --show-uri
# }