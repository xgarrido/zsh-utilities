# -*- mode: shell-script; -*-

function __set_path ()
{
    __pkgtools__at_function_enter __set_path
    export HOSTNAME=$(hostname)

    if [ -z "${ZSH_SETUP_DONE}" ]; then
        case "$HOSTNAME" in
            garrido-laptop|pc-91089)
                # Load RVM function (Ruby manager)
                [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

                # Home made latex style
                export TEXMFHOME=$HOME/.config/texmf

                # Load Go Programming Language
                export GOPATH=$HOME/Development/go
                pkgtools__add_path_to_PATH $GOPATH/bin

                # Adding also /usr/local/lib to LD_LIBRARY_PATH
                pkgtools__add_path_to_LD_LIBRARY_PATH /usr/local/lib

                # Adding utilities path
                pkgtools__add_path_to_PATH $HOME/.bin

                # Set HOST
                export HOST=${HOSTNAME}
                export WORKDIR=~/Workdir
                ;;
            lx3.lal.in2p3.fr|nemo*.lal.in2p3.fr)
                umask 022
                export WORKDIR=/exp/nemo/garrido
                pkgtools__add_path_to_PATH /exp/nemo/install/bin
                pkgtools__add_path_to_PATH /exp/nemo/garrido/software/bin
                pkgtools__add_path_to_LD_LIBRARY_PATH /exp/nemo/garrido/software/lib
                pkgtools__add_path_to_LD_LIBRARY_PATH /exp/nemo/install/lib

                # Add TeXLive 2012
                pkgtools__add_path_to_PATH /exp/nemo/garrido/software/texlive/2012/bin/x86_64-linux
                unset TEXMFCNF
                unset TETEXDIR

                # Add python path
                pkgtools__add_path_to_env_variable PYTHONPATH /exp/nemo/garrido/software/lib/python2.6/site-packages

                # Load Go Programming Language
                export GOROOT=/exp/nemo/garrido/software/go
                pkgtools__add_path_to_PATH /exp/nemo/garrido/software/go/bin
                export GOPATH=$WORKDIR/development/go
                pkgtools__add_path_to_PATH $GOPATH/bin
                ;;
            auger*.lal.in2p3.fr)
                umask 022
                export WORDKDIR=/exp/auger/xavier
                ;;
            ccige*|ccage*)
                export SW_BASE_DIR=${GROUP_DIR}/sw2
                export SCRATCH_DIR=/sps/nemo/scratch/garrido
                source ${SW_BASE_DIR}/config/current/nemo_basics_sw.bash > /dev/null 2>&1 \
                    && do_nemo_basics_sw_setup > /dev/null 2>&1
                ;;
            SynoServer)
                ;;
            *)
                # Load Go Programming Language
                export GOPATH=$HOME/Development/go
                pkgtools__add_path_to_PATH $GOPATH/bin
              ;;
        esac
        export ZSH_SETUP_DONE=1
    fi

    __pkgtools__at_function_exit
    return 0
}

function __reset_path ()
{
    __pkgtools__at_function_enter __reset_path
    unset ZSH_SETUP_DONE
    __set_path
    __pkgtools__at_function_exit
    return 0
}

# Define some aliases
alias reset_path='__reset_path'

# Run function at launch time
__set_path
