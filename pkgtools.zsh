# -*- mode: shell-script; -*-

# Copyright (C) 2012 Xavier Garrido
#
# Author: garrido@lal.in2p3.fr
# Keywords: pkgtools
# Requirements:
# Status: not intended to be distributed yet

# 'pkgtools' message handling and function facilities

# Default values
function pkgtools__default_values ()
{
    __pkgtools__msg_use_color=1
    __pkgtools__msg_use_date=0
    __pkgtools__msg_split_lines=0
    __pkgtools__msg_quiet=0
    __pkgtools__msg_verbose=0
    __pkgtools__msg_warning=1
    __pkgtools__msg_debug=0
    __pkgtools__msg_devel=0
    __pkgtools__msg_funcname=""
    __pkgtools__msg_funcname_deps=""
    __pkgtools__ui_interactive=1
    __pkgtools__ui_gui=0
    return 0
}

#
# UI utilities:
#

function pkgtools__ui_interactive ()
{
    __pkgtools__ui_interactive=1
    return 0
}

function pkgtools__ui_batch ()
{
    __pkgtools__ui_interactive=0
    return 0
}

function pkgtools__ui_is_interactive ()
{
    if [ "x${PKGTOOLS_BATCH}" != "x" ]; then
	if  [ "x${PKGTOOLS_BATCH}" != "x0" ]; then
	    return 1 # false;
	fi
    fi

    if [ ${__pkgtools__ui_interactive} = 1 ]; then
	return 0 # true
    fi
    return 1 # false
}

function pkgtools__ui_is_batch ()
{
    pkgtools__ui_is_interactive
    if [ $? -eq 0 ]; then
	return 1
    fi
    return 0 # true
}

function pkgtools__ui_is_gui ()
{
    if [ ${__pkgtools__ui_gui} = 1 ]; then
	return 0 # true
    fi
    return 1 # false
}


function pkgtools__ui_using_gui ()
{
    __pkgtools__at_function_enter pkgtools__ui_using_gui
    pkgtools__ui_is_batch
    if [ $? -eq 0 ]; then
	pkgtools__msg_warning "Forcing interactive mode !"
	pkgtools__ui_interactive
    fi
    __pkgtools__ui_gui=1
    __pkgtools__at_function_exit
    return 0
}


function pkgtools__ui_not_using_gui ()
{
    __pkgtools__ui_gui=0
    return 0
}

#
# Function facilities
#

function pkgtools__set_funcname ()
{
    local fname=$1
    if [ "x${fname}" != "x" ]; then
	if [ "x${__pkgtools__msg_funcname_deps}" != "x" ]; then
	    __pkgtools__msg_funcname_deps="${__pkgtools__msg_funcname_deps}@${fname}"
	else
	    __pkgtools__msg_funcname_deps=${fname}
	fi
    fi
    __pkgtools__msg_funcname=${fname}
    return 0
}


function pkgtools__unset_funcname ()
{
    local fname=$(echo ${__pkgtools__msg_funcname_deps} | tr "@" "\n" | tail -1)
    if [ "x${__pkgtools__msg_funcname_deps}" != "x" ]; then
	nfuncs=$(echo ${__pkgtools__msg_funcname_deps} | tr '@' '\n' | wc -l)
 	let ncut=nfuncs-1
 	tmp=$(echo -n ${__pkgtools__msg_funcname_deps} | tr "@" "\n" | head -${ncut} | tr '\n' '@' | sed 's/@$//g')
	if [ ${ncut} -eq 0 ]; then
	    tmp=
	fi
	__pkgtools__msg_funcname_deps=${tmp}
    fi
    local previous_fname=$(echo ${__pkgtools__msg_funcname_deps} | tr "@" "\n" | tail -1)
    __pkgtools__msg_funcname=${previous_fname}
    return 0
}

function __pkgtools__at_function_enter ()
{
    pkgtools__set_funcname $1
    pkgtools__msg_devel "Entering..."
    return 0
}

function __pkgtools__at_function_exit ()
{
    pkgtools__msg_devel "Exiting."
    pkgtools__unset_funcname
    return 0
}

#
# Colorized message utilities:
#

# Notes:
# echo -e "\e[1;4;31;42m"
# echo -e "\e[m"

function pkgtools__msg_color_normal ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;39m" 1>&2
    fi
    return 0
}


function pkgtools__msg_color_bold ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[1;1m" 1>&2
    fi
    return 0
}


function pkgtools__msg_color_underline ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;38m" 1>&2
    fi
    return 0
}


function pkgtools__msg_color_red ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;31m" 1>&2
    fi
    return 0
}


function pkgtools__msg_color_bright_red ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;31m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_green ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;32m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_brown ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;33m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_blue ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;34m" 1>&2
    fi
    return 0
}


function pkgtools__msg_color_violet ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;35m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_grey ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[0;37m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_white ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[1;37m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_black ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[1;39m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_reverse ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[1;7m" 1>&2
    fi
    return 0
}

function pkgtools__msg_color_no_reverse ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[1;27m" 1>&2
    fi
    return 0
}


function pkgtools__msg_color_blink ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "" 1>&2
    fi
    return 0
}


function pkgtools__msg_color_no_blink ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "" 1>&2
    fi
    return 0
}


function pkgtools__msg_color__cancel ()
{
    if [ ${__pkgtools__msg_use_color} = 1 ]; then
        echo -en "\\033[1;m" 1>&2
    fi
    return 0
}

function pkgtools__highlight ()
{
    pkgtools__msg_color_bright_red
    echo -en "$@" 1>&2
    pkgtools__msg_color_normal
    return 0
}

#
# Message log utilities:
#

function pkgtools__msg_using_warning ()
{
    __pkgtools__msg_warning=1
    return 0
}

function pkgtools__msg_not_using_warning ()
{
    __pkgtools__msg_warning=0
    return 0
}

function pkgtools__msg_using_verbose ()
{
    __pkgtools__msg_verbose=1
    return 0
}

function pkgtools__msg_not_using_verbose ()
{
    __pkgtools__msg_verbose=0
    return 0
}

function pkgtools__msg_using_quiet ()
{
    pkgtools__msg_using_verbose
    __pkgtools__msg_quiet=1
    return 0
}

function pkgtools__msg_not_using_quiet ()
{
    __pkgtools__msg_quiet=0
    return 0
}

function pkgtools__msg_is_quiet ()
{
    local quiet_ret=1 # false
    if [ "x${PKGTOOLS_MSG_QUIET}" != "x" ]; then
	if [ "x${PKGTOOLS_MSG_QUIET}" != "x0" ]; then
	    quiet_ret=0 # false
	fi
    else
	if [ ${__pkgtools__msg_quiet} -eq 1  ]; then
	    quiet_ret=0 # true
	fi
    fi
    return ${quiet_ret}
}

function pkgtools__msg_using_debug ()
{
    __pkgtools__msg_debug=1
    return 0
}

function pkgtools__msg_not_using_debug ()
{
    __pkgtools__msg_debug=0
    return 0
}

function pkgtools__msg_using_devel ()
{
    __pkgtools__msg_devel=1
    return 0
}

function pkgtools__msg_not_using_devel ()
{
    __pkgtools__msg_devel=0
    return 0
}

function pkgtools__msg_using_date ()
{
    __pkgtools__msg_use_date=1
    return 0
}

function pkgtools__msg_not_using_date ()
{
    __pkgtools__msg_use_date=0
    return 0
}

function pkgtools__msg_using_color ()
{
    __pkgtools__msg_use_color=1
    return 0
}

function pkgtools__msg_not_using_color ()
{
    __pkgtools__msg_use_color=0
    pkgtools__msg_color_normal
    return 0
}

function __pkgtools__base_msg_prefix ()
{
    local log_file=
    if [ "x${PKGTOOLS_LOG_FILE}" != "x" ]; then
	log_file=${PKGTOOLS_LOG_FILE}
    else
	log_file=/dev/null
    fi
    local msg_prefix="$1"
    (
	(
	    echo -n "${msg_prefix}: "
	) | tee -a ${log_file}
    ) 1>&2
    return 0
}

function __pkgtools__base_msg ()
{
    local log_file=
    if [ "x${PKGTOOLS_LOG_FILE}" != "x" ]; then
	log_file=${PKGTOOLS_LOG_FILE}
    else
	log_file=/dev/null
    fi
    (
	(
	    if [ ${__pkgtools__msg_use_date} -eq 1 ]; then
		date +%F-%T | tr -d '\n'
		echo -n " @ "
	    fi
	    if [ "x${appname}" != "x" ]; then
		echo -n "${appname}: "
	    fi
	    if [ "x${__pkgtools__msg_funcname}" != "x" ]; then
		echo -n "${__pkgtools__msg_funcname}: "
	    fi
	    if [ ${__pkgtools__msg_split_lines} -eq 1 ]; then
		echo ""
		echo -n "  "
	    fi
	    echo "$@"
	) | tee -a ${log_file}
    ) 1>&2
    return 0;
}

function pkgtools__msg_err ()
{
    pkgtools__msg_color_red
    __pkgtools__base_msg_prefix "ERROR"
    __pkgtools__base_msg $@
    pkgtools__msg_color_normal

    pkgtools__ui_is_interactive
    if [ $? -ne 0 ]; then
	return 0
    fi
    pkgtools__ui_is_gui
    if [ $? -eq 0 ]; then
	message="$@"
	${__pkgtools__ui_dialog_bin} --title "pkgtools GUI" \
	    --colors --msgbox "\Z1ERROR:\n\Zn ${message}" 10 40
	return 0
    fi
    return 0
}


function pkgtools__msg_error ()
{
    pkgtools__msg_err $@
    return 0
}


function pkgtools__msg_warning ()
{
    if [ ${__pkgtools__msg_warning} -eq 0 ]; then
	return 0
    fi
    pkgtools__msg_color_violet
    __pkgtools__base_msg_prefix "WARNING"
    __pkgtools__base_msg  $@
    pkgtools__msg_color_normal

    pkgtools__ui_is_interactive
    if [ $? -ne 0 ]; then
	return 0
    fi
    pkgtools__ui_is_gui
    if [ $? -eq 0 ]; then
	message="$@"
	${__pkgtools__ui_dialog_bin} --title "pkgtools GUI" \
	    --colors --msgbox "\Z5WARNING:\n\Zn ${message}" 10 40
	return 0
    fi
    return 0
}


function pkgtools__msg_info ()
{
    pkgtools__msg_is_quiet
    if [ $? -eq 0 ]; then
	return 0
    fi

    if [ ${__pkgtools__msg_verbose} -eq 0 ]; then
	return 0
    fi

    pkgtools__msg_color_blue
    __pkgtools__base_msg_prefix "INFO"
    __pkgtools__base_msg  $@
    pkgtools__msg_color_normal

    pkgtools__ui_is_interactive
    if [ $? -ne 0 ]; then
	return 0
    fi
    pkgtools__ui_is_gui
    if [ $? -eq 0 ]; then
	message="$@"
	${__pkgtools__ui_dialog_bin} --title "pkgtools GUI" \
	    --colors --msgbox "\Z4\ZbINFO:\n\Zn ${message}" 10 40
	return 0
    fi
    return 0
}


function pkgtools__msg_verbose ()
{
    pkgtools__msg_info $@
    return 0
}


function pkgtools__msg_notice ()
{
    pkgtools__msg_is_quiet
    if [ $? -eq 0 ]; then
	return 0
    fi

    pkgtools__msg_color_blue
    __pkgtools__base_msg_prefix "NOTICE"
    __pkgtools__base_msg "$@"
    pkgtools__msg_color_normal

    pkgtools__ui_is_interactive
    if [ $? -ne 0 ]; then
	return 0
    fi
    pkgtools__ui_is_gui
    if [ $? -eq 0 ]; then
	message="$@"
	term_nl=$(stty size | cut -d' ' -f1)
	term_nc=$(stty size | cut -d' ' -f2)
	let max_nlines=term_nl-3
	let max_ncols=term_nc-4
	nl=$(echo -e "${message}" | wc -l)
	let nlines=nl+4
	if [ ${nlines} -gt ${max_nlines} ]; then
	    nlines=${max_nlines}
	fi
	if [ ${nlines} -lt 6 ]; then
	    nlines=6
	fi
	${__pkgtools__ui_dialog_bin} --title "pkgtools GUI" \
	    --colors --msgbox "\Z4NOTICE:\n\Zn ${message}" ${nlines} ${max_ncols}
	return 0
    fi
    return 0
}


function pkgtools__msg_highlight_notice ()
{
    pkgtools__msg_color_green
    __pkgtools__base_msg_prefix "NOTICE"
    __pkgtools__base_msg $@
    pkgtools__msg_color_normal

    pkgtools__ui_is_interactive
    if [ $? -ne 0 ]; then
	return 0
    fi
    pkgtools__ui_is_gui
    if [ $? -eq 0 ]; then
	message="$@"
	${__pkgtools__ui_dialog_bin} --title "pkgtools GUI" \
	    --colors --msgbox "\Z4\ZbNOTICE:\n\Zn ${message}" 10 40
	return 0
    fi
    return 0
}


function pkgtools__msg_devel ()
{
    if [ ${__pkgtools__msg_devel} -eq 0 ]; then
	return 0
    fi
    ok=1
    if [ ${ok} -eq 1 ]; then
	pkgtools__msg_color_reverse
	__pkgtools__base_msg_prefix "DEVEL"
	__pkgtools__base_msg $@
	    #__pkgtools__base_msg_2 $@
	pkgtools__msg_color_no_reverse
    fi
    pkgtools__msg_color_normal
    return 0
}


function pkgtools__msg_debug ()
{
    if [ ${__pkgtools__msg_debug} -eq 0 ]; then
	return 0
    fi
    ok=1
    if [ ${ok} -eq 1 ]; then
	pkgtools__msg_color_brown
	__pkgtools__base_msg_prefix "DEBUG"
	__pkgtools__base_msg  $@
	pkgtools__msg_color_normal
    fi
    return 0
}



# end
