# -*- mode: shell-script; -*-

# Copyright (C) 2012 Xavier Garrido
#
# Author: garrido@lal.in2p3.fr
# Keywords: functions
# Requirements:
# Status: not intended to be distributed yet

plugins=(
    pkgtools.zsh
    alias.zsh
    emacs.zsh
    function.zsh
    path.zsh
    svn.zsh
    work.zsh
)

local_dir=$(dirname $0)

for plugin in ${plugins}; do
    source $local_dir/$plugin
done


# end
