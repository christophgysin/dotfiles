# bash aliases

# shortcuts
alias l='ls -lh --color=auto'
alias ll='ls -la --color=auto'
g(){ i=$1; shift; grep $i -In --color -r $*;}
alias c='clear'
alias t='vim ~/todo'
alias b='vim ~/bugs'
alias m='mplayer -fs'
alias tv='mplayer -fs dvb://'
alias ml='m -framedrop -autosync 30 -cache 8192 -vfm ffmpeg -lavdopts lowres=3:fast:skiploopfilter=all'
alias ms='m -ao null'
alias bt='screen -S bt bittorrent-curses'
type ack &>/dev/null || alias ack=ack-grep

# sudo
alias r='sudo su -'
alias svim='sudo vim'

# custom commands
alias psgrep='ps auxwww | grep -v grep | grep'
alias histgrep='history | grep'
addpubkey(){ ssh $1 "mkdir -p .ssh; cat>>.ssh/authorized_keys"<~/.ssh/id_rsa.pub;}
alias grab='sudo chown -R $(id -u):$(id -g)'
alias terminfo-urxvt='sudo ln -s rxvt /usr/share/terminfo/r/rxvt-unicode'
alias checkmail="ssh fr33z3@luzifer.fr33z3.org fetchmail"
alias shortprompt='export PS1="${PS1//w/W}"'
alias sync='rsync -avy --delete --progress --stats --exclude lost+found'
alias sync-pool='sync --exclude movies --exclude tmp /mnt/pool/ /mnt/bay/'
alias sync-movies='sync /mnt/pool/movies/ /mnt/bay/'
mergedir(){ sudo tar c -C "$1" . | sudo tar xvp -C "$2"; }
alias indent="indent -bad --blank-lines-after-procedures -bli0 -i4 -l79 -ncs"\
" -npcs -nprs -npsl -fca -lc79 -fc1 -ts4 -nsaf -nsai -nsaw"
indentdir(){ indent $(find . -regextype posix-extended -regex '.*\.(cpp|c|h)$'); }
urxvtcd(){ urxvtc "$@"; [ $? -eq 2 ] && urxvtd -q -o -f && urxvtc "$@"; }
alias udevattr='/sbin/udevadm info --attribute-walk --name'

# default opts
#alias vim='vim -p'
alias man='man -a'
alias df='df -h'
alias du='du -h'
alias nload='nload -i 102400 -o 102400 -t 500'
#alias ctags='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'
#alias ctags='ctags-exuberant'
alias erl='rlwrap -H ~/.erl_history erl -setcookie erlang'
alias xpdesktop='rdesktop -u gysin -d LN_DOMAIN -z -k de-ch -a 16 -N gysin.swissphone.ch'

# hosts
alias luzifer='ssh chris@luzifer.fr33z3.org'
alias nas='ssh root@nas.fr33z3.org'
alias radio='ssh root@radio.fr33z3.org'

# tunnels
sshtunnel(){ sudo ssh -fNL $2:$1 fr33z3@luzifer.fr33z3.org; }
sshRtunnel(){ sudo ssh -fNR $2:$1 fr33z3@luzifer.fr33z3.org; }
alias imapstunnel='sshtunnel luzifer.fr33z3.org:993 9993'
alias smtptunnel='sshtunnel luzifer.fr33z3.org:25 2525'
alias nntptunnel='sshtunnel luzifer.fr33z3.org:119 1119'
alias httpstunnel='sshtunnel luzifer.fr33z3.org:443 4443'
alias passivesshd='sshRtunnel localhost:22 2222'

# arch
alias pacu='sudo pacman -Syu'
alias pacs='pacman -Ss'
alias paci='sudo pacman -S'
alias pacr='sudo pacman -R'
alias pacl='pacman -Ql'
alias pacm='makepkg -si'
alias pacp='sudo pacman -U'
alias pacf='pkgfile'

# gentoo
alias esync='sudo /usr/sbin/esync'
alias fmerge='sudo emerge -avtf'
alias pmerge='sudo emerge -avt --keep-going y'
alias unmerge='sudo emerge -avtC'
alias cmerge='sudo emerge -avtPO'
alias pworld='sudo emerge -avtu --keep-going y world'
alias fworld='sudo emerge -avtuf world'
alias dworld='sudo emerge -avtuD world'
alias nworld='sudo emerge -avtN world'
alias gcheck='glsa-check -v -l'
keywords() { grep -EH '^KEYWORDS=' /usr/portage/*/$1/*.ebuild|
sed -e 's:/usr/portage/::' -e 's/.ebuild:/: /' -e 's:/.*/:/:';}
usedesc() { grep $1 /usr/portage/profiles/use.*; }
addline() { f=$1; shift; sudo bash -c "(echo -n '# '; date; echo \"$*\") >> $f"; }
alias addkeyword='addline /etc/portage/package.keywords/local'
alias adduse='addline /etc/portage/package.use/local'
alias addmask='addline /etc/portage/package.mask/local'
alias addunmask='addline /etc/portage/package.unmask/local'
alias update-config="sudo dispatch-conf; sudo etc-update"
alias revdep-fix="sudo revdep-rebuild -i -- -avt"

# debian
alias apti='sudo aptitude install'
alias aptr='sudo aptitude remove'
alias apts='sudo aptitude search'
alias aptf='sudo apt-file search'
alias aptud='sudo aptitude update'
alias aptug='sudo aptitude safe-upgrade'
alias dpkgi='dpkg --get-selections | grep install | grep'

PATH=${PATH}:${HOME}/.bin
HISTCONTROL=ignoredups
unset MAILCHECK

complete -cf sudo

[ $(id -un) = root ] &&
   export PS1="\[\033[01;31m\]\h\[\033[01;34m\] \w \$\[\033[00m\] " ||
   export PS1="\[\033[01;32m\]\u \[\033[01;31m\]\\h\[\033[01;34m\] \w \$\[\033[00m\] "

[ -f /usr/share/pkgtools/pkgfile-hook.bash ] && . /usr/share/pkgtools/pkgfile-hook.bash
