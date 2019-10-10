# .bashrc

# source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

function lacount {
cat /proc/loadavg |awk '{print $1}';
}

function currentuser {
        whoami
}

# user specific aliases and functions
# prompt settings
CHECK_SHELL=$( echo $SHELL | sed 's/^.*\///' )
if [ x"$CHECK_SHELL" = xbash ]; then
        export FULL_HOSTNAME=$( hostname -f 2>/dev/null || hostname )
        export SHORT_HOSTNAME=$( hostname -s 2>/dev/null || hostname )
        ME=$( whoami )
        if [ ${EUID} == 0 ] ; then
                PS1='\[\e[1;37;49m\][ \[\033[0;33m\]\t\[\033[01;34m\]\[\e[1;37;49m\] PWD:\w ]\[\033[01;31m\]\n\[\033[01;31m\]$ME@$SHORT_HOSTNAME \[\033[01;31m\][Asgardahost] $ \[\033[00m\]'
                PROMT_COLOR="\[\033[01;31m\]"
        else
                PS1='\[\e[1;37;49m\][ \[\033[0;33m\]\t\[\033[01;34m\]\[\e[1;37;49m\] PWD:\w ]\[\033[01;32m\]\n\[\033[01;32m\]$ME@$SHORT_HOSTNAME \[\033[01;32m\][Asgardahost] $ \[\033[00m\]'
                PROMT_COLOR="\[\033[01;32m\]"
        fi
        # prompt formattings
        #PS1='$PROMT_COLOR $ME@$SHORT_HOSTNAME \[\e[1;37;49m\][ \[\033[0;33m\]\t\[\033[01;34m\]\[\e[1;37;49m\] LA: `lacount` PWD:\w ]\[\033[01;31m\] $ \[\033[00m\]'
        GIT_PROMPT_START_ROOT="\[\033[0;33m\]\t\[\033[01;34m\] \w\[\033[00m\]"
        GIT_PROMPT_END_ROOT="\n$PROMT_COLOR\u@$FULL_HOSTNAME\[\033[01;34m\] \$\[\033[00m\] "
        GIT_PROMPT_START_USER=$GIT_PROMPT_START_ROOT
        GIT_PROMPT_END_USER=$GIT_PROMPT_END_ROOT
fi

case $TERM in
        screen*)
                PROMPT_COMMAND='echo -ne "\033k${HOSTNAME} $( whoami )\033\\"'
                ;;
        *)
                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
                ;;
esac

# history settings
export HISTCONTROL=ignoreboth
shopt -s histappend
export HISTTIMEFORMAT="%d/%m/%y %T "
HISTSIZE=9999999

# aliases
if [ x$(uname) = xLinux ]; then
        alias ll='ls -alFh --color=auto'
        alias la='ls -A --color=auto'
        alias l='ls -CF --color=auto'
        alias ltr='ls -ltr --color=auto'
else
        alias ll='ls -alGh'
fi
alias pp='ps afxo pid,user,tty,nice,state,%cpu,%mem,rss,vsz,lstart,bsdtime,stat,command'
alias unvary-ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias grpe='grep'
alias tsmark='perl -pe '"'"'$|=1; my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = gmtime(time); printf "%04d-%02d-%02dT%02d:%02d:%02d > ", 1900 + $year, $mon + 1, $mday, $hour, $min, $sec;'"'"
alias rm='rm -i'
alias cp='cp -v'
alias mv='mv -v'
alias grep='grep --colour=auto'
[ -f /usr/local/bin/vim ] && alias vi='/usr/local/bin/vim'
[ -f /usr/bin/vim ] && alias vi='/usr/bin/vim'
alias less='less -x4'
alias mtr='mtr -t'
alias s='su -m'
alias pagent_noop='puppet agent -t --noop'
alias pagent='puppet agent -t'

# env
export LESS='-IMSR'
export LESS_TERMCAP_mb=$'\033[01;31m'
export LESS_TERMCAP_md=$'\033[01;31m'
export LESS_TERMCAP_me=$'\033[0m'
export LESS_TERMCAP_se=$'\033[0m'
export LESS_TERMCAP_so=$'\033[01;44;33m'
export LESS_TERMCAP_ue=$'\033[0m'
export LESS_TERMCAP_us=$'\033[01;32m'
export SVN_EDITOR="vim"
export GIT_EDITOR="vim"
export EDITOR="vim"
export GIT_SSL_NO_VERIFY="false"
export LANG="en_US.UTF-8"
export FTP_PASSIVE_MODE="YES"
export GOPATH=$HOME/lib/go
export PATH=$PATH:$HOME/.local/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/sbin:/opt/bin:/opt/local/bin:$GOPATH/bin:/cloud/bin:/usr/local/scripts:/opt/puppetlabs/bin:/opt/virtualenvs/ansible/bin:/opt/virtualenvs/ansible/lib:/opt/virtualenvs/ansible/lib64

# banner
if [[ $- == *i* ]] ; then
        if [[ -d /etc/motd ]]; then
                COUNT=$(ls /etc/motd/ | wc -l)
                cat /etc/motd/cats_$(echo $((RANDOM%$COUNT+1)) )
                alias randomcat="cat /etc/motd/cats_\$(echo \$((RANDOM%$COUNT+1)) )"
        fi
fi

# sources
if [[ -f $HOME/.git-completion.sh ]]; then
        source $HOME/.git-completion.sh
fi

GIT_PROMPT_ONLY_IN_REPO=1
if [[ -f $HOME/.bash-git-prompt/gitprompt.sh ]]; then
        source $HOME/.bash-git-prompt/gitprompt.sh
fi

# screen settings
export SCREENDIR=$HOME/.screen

###Add xkb for Qt
export QT_XKB_CONFIG_ROOT=/usr/share/X11/xkb

###Allow on-network local connections being added to access control list - need this to run Docker and other that require X
xhost +local:

