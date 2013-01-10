# -*- mode: shell-script; -*-

# Copyright (C) 2012 Xavier Garrido
#
# Author: garrido@lal.in2p3.fr
# Keywords:
# Requirements:
# Status: not intended to be distributed yet

# 'unison' functions to watch a given directory and send their changes
# to somewhere else

local __munison_bin="/home/garrido/Development/bash/munison"

function watch_for_server ()
{
    ${__munison_bin} start --machine pc $@ && winfo
}

function watch_for_nemo3 ()
{
    ${__munison_bin} start --machine nemo3 $@ && winfo
}

function watch_for_nemo4 ()
{
    ${__munison_bin} start --machine nemo4 $@ && winfo
}

function watch_start ()
{
    ${__munison_bin} start $@ && winfo
}
alias wstart='watch_start'

function watch_info ()
{
    ${__munison_bin} info $@
}
alias winfo='watch_info'

function watch_restart ()
{
    ${__munison_bin} restart --id $@ && winfo
}
alias wrestart='watch_restart'

function watch_stop ()
{
    ${__munison_bin} stop --id $@ && winfo
}
alias wstop='watch_stop'

function watch_remove ()
{
    ${__munison_bin} remove --id $@ && winfo
}
alias wremove='watch_remove'

function watch_restart_all ()
{
    ${__munison_bin} restart --all $@ && winfo
}
alias wra='watch_restart_all'

function watch_restart_only_pending ()
{
    ${__munison_bin} restart --all --only-pending $@ && winfo
}
alias wrop='watch_restart_only_pending'

function watch_stop_all ()
{
    ${__munison_bin} stop --all $@ && winfo
}
alias wsa='watch_stop_all'

function watch_remove_all ()
{
    ${__munison_bin} remove --all $@ && winfo
}

function watch_reset_all ()
{
    ${__munison_bin} reset $@ && winfo
}

function kill_all_remote_monitor ()
{
    ${__munison_bin} kill-remote
}

# end