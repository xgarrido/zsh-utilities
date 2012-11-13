# -*- mode: shell-script; -*-
### Emacs daemon stuff
function run_emacs_daemon
{
    pid=$(ps -edf | grep ${USER} | grep emacs| grep daemon | awk '{print $2}')
    if [[ "${pid}" == "" ]]; then
        \emacs --daemon > /dev/null 2>&1 && notify -t 1000 -u low -i emacs "Emacs" "Restart daemon done"
    fi
}

function relaunch_emacs_daemon
{
    pid=$(ps -edf | grep ${USER} | grep emacs | grep daemon | awk '{print $2}')
    if [[ "${pid}" != "" ]]; then
        kill -9 ${pid}
    fi

    run_emacs_daemon
    if [[ "$1" != "" ]]; then
        emacs -e "(my-desktop)" $1
    else
        emacs -e "(my-desktop)"
    fi

}
###
