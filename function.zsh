# -*- mode: shell-script; -*-

# Copyright (C) 2012 Xavier Garrido
#
# Author: garrido@lal.in2p3.fr
# Keywords:
# Requirements:
# Status: not intended to be distributed yet

# Several useful user functions

function svn_up_home_all ()
{
    __pkgtools__at_function_enter svnup_home_all
    pkgtools__msg_notice "Updating home config on LAL machines"
    ssh garrido@lx3.lal.in2p3.fr "/exp/nemo/garrido/software/bin/svn up"
    if [ $? -ne 0 ]; then
        pkgtools__msg_error "Something fails during update"
        __pkgtools__at_function_exit
        return 1
    fi

    pkgtools__msg_notice "Updating home config on PC server"
    if [ "${HOSTNAME}" = "garrido-laptop" ]; then
        ssh -p 6263 garrido@localhost "svn up"
    else
        ssh garrido@pc-91089.lal.in2p3.fr "svn up"
    fi
    if [ $? -ne 0 ]; then
        pkgtools__msg_error "Something fails during update"
        __pkgtools__at_function_exit
        return 1
    fi

    __pkgtools__at_function_exit
    return 0
}

# EVO meeting using koala app
function koala ()
{
    /usr/lib/jvm/java-6-sun/bin/javaws /home/garrido/.KoalaNext/koala.jnlp
}

# Connection to LAL machines
function connect ()
{
    __pkgtools__at_function_enter connect
    local use_screen=0
    local server_name=
    local ssh_option=
    local append_command=

    if [[ "$1" == "" ]]; then
	echo "Missing the name of machine to connect !"
        echo ""
        echo "Machines can be :"
        echo "         fzk : FZK machines (deprecated)"
        echo "        cern : CERN machines"
        echo " ccage|ccige : CC Lyon "
        echo "         ovh : OVH server (thanks to Jérémie )"
        echo "          pc : PC @ LAL"
        echo "      laptop : Laptop @ LAL"
        echo "         mac : Mac @ home"
        echo "        syno : Synology @ home"
        echo "      debian : Debian @ home"
        echo ""
        echo " Nemo computers :"
        echo "     nemo* : nemo machines"
        echo "  daq-nemo : DAQ pc-nemo12 (salle blanche)"
        echo "   daq-lsm : DAQ lsmlx5 (interface computer @ Modane)"
        echo ""
        echo " LAL/Auger computers :"
        echo " lx*, auger* ... : connect to LAL machine"
        echo ""
        return 1
    fi

    while [ -n "$1" ]; do
        if [[ "$1" == "-s" ]]; then
        use_screen=1
        elif [[ "$1" == "fzk" ]]; then
            ssh_option="-p 24"
            server_name="augerlogin.fzk.de"
        elif [[ "$1" == "cern" ]]; then
            server_name="xgarrido@lxplus.cern.ch"
        elif [[ "$1" == "lyon" ]]; then
            local bin="useless_ssh_pwd.sh"
            which ${bin} > /dev/null
            if [ $? -ne 0 ]; then
                pkgtools__msg_warning "'useless_ssh_pwd.sh' binary has not been found! Exit!"
                server_name="ccage.in2p3.fr"
            else
                ${bin} baia ccage.in2p3.fr garrido
            fi
            return 0
        elif [[ $1 == ccige* ]]; then
            server_name="garrido@$1.in2p3.fr"
        elif [[ $1 == ccage* ]]; then
            server_name="garrido@$1.in2p3.fr"
        elif [[ "$1" == "ovh" ]]; then
            ssh_option="-p 1234"
            server_name="garrido@r17187.ovh.net"
        elif [[ "$1" == "laptop" ]]; then
            server_name="garrido@nb-76121.lal.in2p3.fr"
        elif [[ "$1" == "mac" ]]; then
            ssh_option="-p 24"
            server_name="garrido@xgarrido.dyndns.org"
        elif [[ "$1" == "syno" ]]; then
            echo "Connecting via telnet ..."
            telnet -l garrido xgarrido.dyndns.org
        elif [[ "$1" == "debian" ]]; then
            server_name="debian@xgarrido.dyndns.org"
        elif [[ "$1" == "lx3" ]]; then
            server_name="garrido@lx3.lal.in2p3.fr"
        elif [[ "$1" == "daq-nemo" ]]; then
            server_name="bipolal@pc-nemo12.lal.in2p3.fr"
        elif [[ "$1" == "daq-lsm" ]]; then
            server_name="nemoacq@lsmlx5.in2p3.fr"
        else
            if [ "${HOSTNAME}" = "garrido-laptop" ]; then
                if [[ "$1" == "nemo3" ]]; then
                    ssh_option="-p 6261"
                    server_name="garrido@localhost"
                elif [[ "$1" == "nemo4" ]]; then
                    ssh_option="-p 6262"
                    server_name="garrido@localhost"
                elif [[ "$1" == "pc" ]]; then
                    ssh_option="-p 6263"
                    server_name="garrido@localhost"
                else
                    append_command+="$1 "
                fi
            else
                if [[ "$1" == "pc" ]]; then
                    server_name="pc-91089.lal.in2p3.fr"
                else
                    server_name="$1.lal.in2p3.fr"
                fi
            fi
        fi
        shift 1
    done

    if [ ${use_screen} -eq 0 ]; then
        pkgtools__msg_notice "Connecting to ${server_name}..."
        ssh -Y ${ssh_option} ${server_name} "${append_command}"
    else
        pkgtools__msg_notice "Connecting to ${server_name} with screen support..."
        screen ssh -Y ${ssh_option} ${server_name}
    fi

    __pkgtools__at_function_exit
    return 0
}

# google translate
function translate ()
{
    if [[ "$1" == "" ]]; then
        echo "Missing argument !!"
        echo " translate \"<phrase>\" <source-langage> <output-langage>"
        echo " example : translate \"Hello my friend\" en fr => Bonjour mon ami"
        echo " see http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes for code language"
    else
        wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/';
    fi
}


# mount with sshfs remote disk
function mountDisk ()
{
    if [[ "$1" == "" ]]; then
        echo "Missing the name of the remote disk !"
    elif [[ "$1" == "auger" ]]; then
        if [[ -d /tmp/auger ]]; then
            fusermount -u /tmp/auger
            rm -rf /tmp/auger
        fi
        mkdir /tmp/auger
        echo "sshfs garrido@lx3.lal.in2p3.fr:/exp/auger/xavier /tmp/auger"
        sshfs garrido@lx3.lal.in2p3.fr:/exp/auger/xavier /tmp/auger
    fi
}

function umountDisk ()
{
    if [[ "$1" == "" ]]; then
        echo "Missing the name of the remote disk !"
    elif [[ "$1" == "auger" ]]; then
        echo "fusermount -u /tmp/auger"
        fusermount -u /tmp/auger
        rm -rf /tmp/auger
    fi
}

# Dexter java applet
function dexter ()
{
    if [[ "$1" == "" ]]; then
	echo "Missing the name of image file !"
    else
	java -jar /home/garrido/Workdir/Development/java/dexter/Debuxter.jar $1
    fi
}

# # obsolete !!
# # Jaxodraw java applet
# jaxodraw(){
#     java -jar /home/garrido/Workdir/Development/java/jaxodraw/current/jaxodraw-1.3-2.jar
# }

# # Jabref java applet for bibliography
# jabref(){
#     java -jar /home/garrido/Workdir/Development/java/jabref/current/JabRef-2.2.jar
# }

# Print manual page of command
# this use mpage command to put the result in 2 columns
# if it doesn't exist use the ps2ps command
function man2ps ()
{
    if [[ "$1" == "" ]]; then
	echo "Missing the name of the command !"
    else
	man -t $1 | mpage -bA4 -f -2 > $1.ps
    fi
}
function man2pdf ()
{
    if [[ "$1" == "" ]]; then
	echo "Missing the name of the command !"
    else
	man -t $1 | mpage -bA4 -f -2 > $1.ps && ps2pdf $1.ps $1.pdf && rm -f $1.ps
    fi
}

# Print ps -edf command
# for a defined program
# nothing more than ps -edf | grep $1
function psgrep ()
{
    if [[ ! -z $1 ]] ; then
        echo "Grepping for processes matching $1..."
        ps aux | grep $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}

function hgrep ()
{
    if [[ ! -z $1 ]] ; then
        echo "Grepping for command matching $1..."
        history | grep $1
    else
        echo "!! Need name to grep for"
    fi
}
# bash calculator
function calc ()
{
    echo "$*" | bc -l;
}

# remove trailing whitespace for a given file
function remove_trailing_whitespace ()
{
    if [[ "$1" == "" ]]; then
	echo "Missing the directory !"
    else
        find $1 -type f -exec sed -i 's/ *$//' '{}' ';'
    fi
}

# grab video from mms link
function grab_video ()
{
    if [[ ! -z "$1" ]] ; then
        echo "Grabing video from $1 link and saving it to /tmp/dump_video.avi..."
        mplayer -dumpstream "$1" -dumpfile /tmp/dump_video.avi
    else
        echo "ERROR: !! Need mms link !!"
        return 1
    fi
    return 0
}

# convert EPS figure to tikz
function eps2tikz ()
{
    local use_helvetica=0
    local keep_xfig=0

    local eps_file=

    local parse_switch=1
    while [ -n "$1" ]; do
        token="$1"
        if [[ "${token[1]}" = "-" ]]; then
	    opt=${token}
	    if [[ ${parse_switch} -eq 0 ]]; then
	        break
	    fi
	    if [ "${opt}" = "-h" -o "${opt}" = "--help" ]; then
                cat <<EOF

  eps2tikz

  Usage:

    eps2tikz [Options] figure.eps

  Options:

    -h
    --help       : print this help then exit

    --keep-xfig  : keep the xfig file

EOF
	        return 0
	    elif [ "${opt}" = "--keep-xfig" ]; then
	        keep_xfig=1
	    else
	        echo "ERROR: Ignoring option '${opt}' !"
	        return 1
	    fi
        else
	    arg=${token}
	    parse_switch=0
	    if [ "${arg##*.}" = "eps" ]; then
                eps_file="${eps_file} ${arg}"
	    else
                echo "ERROR: File is not an Encapsulated PostScript"
                return 1
	    fi
        fi
        shift 1
    done

    if [[ -z "${eps_file}" ]]; then
        echo "ERROR: Missing EPS file !"
        return 1
    fi

    for i in $(echo ${eps_file}); do
        if [ ! -f "${i}" ]; then
            echo "WARNING: File ${i} does not exist! Skip it"
            continue
        fi

        local fig_file=${i/.eps/.fig}
        local tikz_file=${i/.eps/.tikz}

        echo "NOTICE: Converting ${i} file to ${tikz_file}..."

        pstoedit -f xfig ${i} > ${fig_file} 2> /dev/null
        ~/Development/scripts/fig2tikz/fig2tikz ${fig_file} > ${tikz_file}

        if [[ ${keep_xfig} -eq 0 ]]; then
            rm -f ${fig_file}
        fi

    done

    return 0
}

# wake pc through LAN
# function wake ()
# {
#     wakeonlan 00:14:22:2e:dc:9c
# }

function shutdown_pc ()
{
    sudo shutdown -h now
}

function extract()
{
  local remove_archive
  local success
  local file_name
  local extract_dir

  if (( $# == 0 )); then
    echo "Usage: extract [-option] [file ...]"
    echo
    echo Options:
    echo "    -r, --remove    Remove archive."
    echo
    echo "Report bugs to <sorin.ionescu@gmail.com>."
  fi

  remove_archive=1
  if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
    remove_archive=0
    shift
  fi

  while (( $# > 0 )); do
    if [[ ! -f "$1" ]]; then
      echo "extract: '$1' is not a valid file" 1>&2
      shift
      continue
    fi

    success=0
    file_name="$( basename "$1" )"
    extract_dir="$( echo "$file_name" | sed "s/\.${1##*.}//g" )"
    case "$1" in
      (*.tar.gz|*.tgz) tar xvzf "$1" ;;
      (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
      (*.tar.xz|*.txz) tar --xz --help &> /dev/null \
        && tar --xz -xvf "$1" \
        || xzcat "$1" | tar xvf - ;;
      (*.tar.zma|*.tlz) tar --lzma --help &> /dev/null \
        && tar --lzma -xvf "$1" \
        || lzcat "$1" | tar xvf - ;;
      (*.tar) tar xvf "$1" ;;
      (*.gz) gunzip "$1" ;;
      (*.bz2) bunzip2 "$1" ;;
      (*.xz) unxz "$1" ;;
      (*.lzma) unlzma "$1" ;;
      (*.Z) uncompress "$1" ;;
      (*.zip) unzip "$1" -d $extract_dir ;;
      (*.rar) unrar e -ad "$1" ;;
      (*.7z) 7za x "$1" ;;
      (*.deb)
        mkdir -p "$extract_dir/control"
        mkdir -p "$extract_dir/data"
        cd "$extract_dir"; ar vx "../${1}" > /dev/null
        cd control; tar xzvf ../control.tar.gz
        cd ../data; tar xzvf ../data.tar.gz
        cd ..; rm *.tar.gz debian-binary
        cd ..
      ;;
      (*)
        echo "extract: '$1' cannot be extracted" 1>&2
        success=1
      ;;
    esac

    (( success = $success > 0 ? $success : $? ))
    (( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
    shift
  done
}

# bc otherwise I get errors on computers that don't have notify-send
function notify
{
    local bin="/usr/bin/notify-send"
    if [ ! -x ${bin} ]; then
        return
    fi

    if [ "$HOSTNAME" = "garrido-laptop" ]; then
        ${bin} $@ > /dev/null 2>&1
    fi
}

function notifyerr ()
{
    if [ "$?" -gt 0 ]; then
#        notify -t 2000 -i stock_dialog-error -u critical "Error" "${PREEXEC_CMD:-Shell Command}"
        notify -t 2000 -i stock_dialog-error "Error" "${PREEXEC_CMD:-Shell Command}"
        return -1
    fi
}

# Screen title names
function precmd ()
{
    # must be first
    notifyerr

    # BEGIN notify long running cmds
    stop=$(date +'%s')
    start=${PREEXEC_TIME:-$stop}
    let elapsed=$stop-$start
    max=${PREEXEC_MAX:-10}

    for i in ${PREEXEC_EXCLUDE_LIST:-}; do
	if [ "x$i" = "x$PREEXEC_CMD" ]; then
	    max=999999;
	    break;
	fi
    done

    if [ $elapsed -gt $max ]; then
	notify -t 2000 -i stock_dialog-warning "${PREEXEC_CMD:-Shell Command}" "finished ($elapsed secs)"
    fi
    # END notify long running cmds

    # Hack to make the prompt working in LAL machine
    case "$HOSTNAME" in
        lx*.lal.in2p3.fr|nemo*.lal.in2p3.fr|ccige*|ccage*)
            PROMPT='%{${ZSH_THEME_NEMO_TIME}%}%T%{$reset_color%} %{${ZSH_THEME_NEMO_HOSTNAME_SUFFIX}${ZSH_THEME_NEMO_HOSTNAME}%}${ZSH_THEME_NEMO_SETUP}${HOSTNAME}%{$reset_color%} %{${ZSH_THEME_NEMO_DIRECTORY}%}${PWD/#$HOME/~}%{$reset_color%}
$ '
    esac
}

function preexec ()
{
    if [[ "$TERM" == "screen" ]]; then
        local CMD=${1}
        echo -ne "\ek$CMD\e\\"
    fi
    # for notifying of long running commands
    export PREEXEC_CMD=`echo $1 | awk '{ print $1; }'`
    export PREEXEC_TIME=$(date +'%s')
}

# ls just afer a cd command
# function chpwd() {
#     emulate -L zsh
#     lla
# }

# end
