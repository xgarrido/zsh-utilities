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
if [[ -x $(which ack-grep) ]]; then
    alias ack='ack-grep'
elif [[ -x $(which /usr/bin/vendor_perl/ack) ]]; then
    alias ack='/usr/bin/vendor_perl/ack'
fi
alias gv='gv -noantialias'
alias ipython='/usr/local/bin/ipython'

alias open='xdg-open'
alias preview='gloobus-preview'
alias mplayer='gnome-mplayer'
alias emacs='emacsclient -c -n'
alias iemacs='emacsclient -n'
alias ve='emacsclient -nw'

# dotfiles https://github.com/jbernard/dotfiles
alias dotfiles='dotfiles -R ~/Development/dotfiles'

# Options for less program are the following:
# -M : Shows more detailed prompt, including file position
# -N : Shows line numbers
# -X : Suppresses the terminal clearing at exit
export PAGER='less -M -N -X'
export EDITOR='emacsclient -nw'
export SVN_EDITOR=$EDITOR
export GIT_EDITOR=$EDITOR
if [ -x "/usr/local/bin/src-hilite-lesspipe.sh" ]; then
    export LESSOPEN="| src-hilite-lesspipe.sh %s"
    export LESS=' -R '
    alias more='less -M -N -X'
fi

# set HOST
export HOST=${HOSTNAME}

####################
# Package manager  #
####################

is_debian=1
pkg_mgr="apt-get"
if [[ -x "/usr/bin/apt-fast" ]]; then
    pkg_mgr="apt-fast"
    is_debian=1
elif [[ -x "/usr/bin/apt-get" ]]; then
    pkg_mgr="apt-get"
    is_debian=1
elif [[ -x "/usr/bin/yaourt" ]]; then
    pkg_mgr="yaourt"
    is_debian=0
elif [[ -x "/usr/bin/pacman" ]]; then
    pkg_mgr="pacman"
    is_debian=0
fi

if [ ${is_debian} -eq 1 ]; then
    alias pkg-notify='notify -t 2000 -i stock_dialog-info "${pkg_mgr}"'

    function install ()
    {
        __pkgtools__at_function_enter install
        sudo ${pkg_mgr} install -y $* && pkg-notify "Installed $@"
        __pkgtools__at_function_exit
        return 0
    }
    compdef "_deb_packages uninstalled" install

    function remove ()
    {
        __pkgtools__at_function_enter remove
        sudo ${pkg_mgr} remove -y $* && pkg-notify "Removed $@"
        __pkgtools__at_function_exit
        return 0
    }
    compdef "_deb_packages installed" remove

    function upgrade ()
    {
        __pkgtools__at_function_enter upgrade
        sudo ${pkg_mgr} update && sudo ${pkg_mgr} upgrade && pkg-notify "Upgrade done"
        __pkgtools__at_function_exit
        return 0
    }

    function search ()
    {
        __pkgtools__at_function_enter upgrade
        apt-cache search $@
        __pkgtools__at_function_exit
        return 0
    }

    function purge ()
    {
        __pkgtools__at_function_enter purge
        sudo ${pkg_mgr} purge && pkg-notify "Purge done"
        __pkgtools__at_function_exit
        return 0
    }

    function distupgrade ()
    {
        __pkgtools__at_function_enter purge
        sudo ${pkg_mgr} update && sudo ${pkg_mgr} dist-upgrade && pkg-notify "Distribution upgrade done"
        __pkgtools__at_function_exit
        return 0
    }

    function autoremove ()
    {
        __pkgtools__at_function_enter purge
        sudo ${pkg_mgr} autoremove && pkg-notify "Autoremove done"
        __pkgtools__at_function_exit
        return 0
    }
fi

# end
