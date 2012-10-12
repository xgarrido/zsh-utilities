# -*- mode: shell-script; -*-
export HOSTNAME=$(hostname)

if [ ! -n "${ZSH_SETUP_DONE}" ]; then
    case "$HOSTNAME" in
        garrido-laptop|pc-91089)

            # run emacs daemon in case it is not already running
            #run_emacs_daemon

            # Load RVM function (Ruby manager)
            [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

            # Load local installation of texlive 2011
            # Ubuntu package version is too old (2009)
            export PATH=$HOME/Development/texlive/2012/bin/i386-linux:$PATH
            export TEXMFHOME=$HOME/.config/texmf

            # Adding also /usr/local/lib to LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

            # Adding rootpy utilities path
            export PATH=$HOME/.local/bin:$PATH

            # set HOST
            export HOST=${HOSTNAME}
            export WORKDIR=~/Workdir
            ;;
        lx3.lal.in2p3.fr|nemo*.lal.in2p3.fr)
            umask 022
            export WORKDIR=/exp/nemo/garrido
            export PATH=/exp/nemo/install/bin:/exp/nemo/garrido/software/bin:${PATH}
            export LD_LIBRARY_PATH=/exp/nemo/garrido/software/lib:/exp/nemo/install/lib:${LD_LIBRARY_PATH}
            # Add TeXLive 2012
            export PATH=/exp/nemo/garrido/software/texlive/2012/bin/x86_64-linux:${PATH}
            unset TEXMFCNF
            unset TETEXDIR
            ;;
        auger*.lal.in2p3.fr)
            umask 022
            export WORDKDIR=/exp/auger/xavier
            ;;
        mac-garrido)
            # add Mac ports binaries
            export PATH=$PATH:/opt/local/bin
            ;;
        ccige*|ccage*)
            export SW_BASE_DIR=${GROUP_DIR}/sw2
            export SCRATCH_DIR=/sps/nemo/scratch/garrido
            source ${SW_BASE_DIR}/config/current/nemo_basics_sw.bash > /dev/null 2>&1 && do_nemo_basics_sw_setup > /dev/null 2>&1
            ;;
        SynoServer)
            ;;
        *)
            ;;
    esac
    export ZSH_SETUP_DONE=1
fi
