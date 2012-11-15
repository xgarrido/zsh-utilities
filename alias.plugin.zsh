# -*- mode: shell-script; -*-
if [[ "$TERM" == "xterm" ]]; then
    export TERM=xterm-256color
fi

# Disable autocorrect for zsh
unsetopt correct_all

# bindkey
bindkey '\C-z' undo

# Aliases
alias ll='ls -ltrh'
alias la='ls -rtha'
alias lla='ls -rthal'
alias lsd='ls -l | grep ^d'
alias tx='LANG=de_DE.ISO-8859-15 nedit'
alias root='root -l'
alias cl='clear'
alias h='history'
alias vi='vim'
alias grep='grep --color=auto'
alias ack='ack-grep'
alias gv='gv -noantialias'
alias ipython='/usr/local/bin/ipython'

alias open='gnome-open'
alias preview='gloobus-preview'
alias mplayer='gnome-mplayer'
alias emacs='emacsclient -c -n'
alias iemacs='emacsclient -n'
alias ve='emacsclient -nw'

# Options for less program are the following:
# -M : Shows more detailed prompt, including file position
# -N : Shows line numbers
# -X : Suppresses the terminal clearing at exit
export PAGER='less -M -N -X'
export SVN_EDITOR='emacsclient -nw'
export GIT_EDITOR='emacsclient -nw'
if [ -x "/usr/local/bin/src-hilite-lesspipe.sh" ]; then
    export LESSOPEN="| src-hilite-lesspipe.sh %s"
    export LESS=' -R '
    alias more='less -M -N -X'
fi

# set HOST
export HOST=${HOSTNAME}

############
#  Apt-get #
############
apt_fast_cmd="apt-get"
if [[ -x "/usr/bin/apt-fast" ]]; then
    apt_fast_cmd="apt-fast"
fi

alias apt-notify='notify -t 2000 -i stock_dialog-info "Apt-get"'

function install
{
    sudo ${apt_fast_cmd} install -y $* && apt-notify "Installed $@"
}
compdef "_deb_packages uninstalled" install

function remove
{
    sudo ${apt_fast_cmd} remove -y $* && apt-notify "Removed $@"
}
compdef "_deb_packages installed" remove

alias arem='sudo apt-get autoremove -y'
alias arep='sudo add-apt-repository'
alias search='apt-cache search'

function purge
{
    sudo ${apt_fast_cmd} purge && apt-notify "Purge done"
}
function upgrade
{
    sudo ${apt_fast_cmd} update && sudo ${apt_fast_cmd} upgrade && apt-notify "Upgrade done"
}

function distupgrade
{
    sudo ${apt_fast_cmd} update && sudo ${apt_fast_cmd} dist-upgrade && apt-notify "Distribution upgrade done"
}

function autoremove
{
    sudo apt-get autoremove && apt-notify "Autoremove done"
}
