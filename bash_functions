# Notify on command end
notime(){
($* ; notify-send "Command over" "$*")
}

# Find text in any file (find grep)
fgr() {
find . -name "${2:-*}" | xargs grep -l "$1"
}

# Copy folder to remote server
putout() {
tar czf - ${1} | ssh ${2} tar xzf - -C ${3}
}

# Extract any archive file
extract() {
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

# Add folder to path if not already exported
pathadd() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

# Example: add ~/bin to user path
if [ -d $HOME/bin ];then pathadd $HOME/bin;fi

# Create sh alias for each script.sh in $HOME/bin
for i in $(ls ~/bin | grep ".sh"); do alias s_$i='sh ~/bin/$i';done;

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

# Replace a text in all given files
replace () {
    perl -e '$a=shift;$b=shift;while($f=shift){open(F,$f);@t=<F>;close(F);\
    map s/$a/$b/,@t;open(W,">$f");print W @t;close(W)}' "$@"
}

# Make cp with .ori backup
cpb() { cp $@{,.ori} ;}

# Copy directory over ssh as: pussh Myfolder ~/Myremotefolder example.com
pussh(){
tar czf - "$1" | ssh @$3 tar xzf - -C $2
}

# Create ssh tunnel as: createTunnel user host.com localport remoteport 
createTunnel()
{
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

#  Ping a host until it responds, then play a sound, then exit
speakwhenup() { 
[ "$1" ] && PHOST="$1" || return 1
until ping -c1 -W2 $PHOST >/dev/null 2>&1 
do 
  sleep 5s 
done
espeak "$PHOST is up" >/dev/null 2>&1
}

### Man pages
# Search
mans () {
    man $1 | grep -iC2 --color=always $2 | less
}

# Needs qarma (zenity like)
qman () {
    man $1 | qarma --text-info --title="Man Page" --width=800 --height=800
}
###

# Limit memory usage of one process (needs qarma)
# Use first argument as the process to limit 
# Optionaly add second arg the memory limit or default is 500M
LimiT() {
NAME=$1			# Process name to check out
MEM_LIM=500000		# Memory limit, in Ko
MEM_LIM=$2		# If no limit specified

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
    if [ -z "$1" ] || [ -d "./$1" ];then exit 1;fi
    mkdir "$1" && cd "$1" && pckcp -gc && sed -i "s/kaos-pkgbuild-proto/$1/g" PKGBUILD
    echo -e "#$1\n" > README.md
    kate -e utf8 -n README.md PKGBUILD
}
