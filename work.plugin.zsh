# -*- mode: shell-script; -*-

function do_nemo_setup ()
{
    nemo_software_version="trunk"
    if [ "x$1" != "x" ]; then
        nemo_software_version="$1"
    fi

    export SNAILWARE_SOFTWARE_VERSION=${nemo_software_version}
    bash --rcfile ~/.bashrc.work
}

########################
# Aliases for pkgtools #
########################

alias pkg-notify='notify -t 2000 -i stock_dialog-info "pkgtools"'

function pkgc
{
    ./pkgtools.d/pkgtool configure $@ && pkg-notify "Configure done"
}

function pkgb
{
    ./pkgtools.d/pkgtool build && pkg-notify "Build done"
}

function pkgt
{
    ./pkgtools.d/pkgtool test && pkg-notify "Running test programs done"
}

function pkgr
{
    ./pkgtools.d/pkgtool reset && pkg-notify "Reset done"
}

function pkgi
{
    ./pkgtools.d/pkgtool install && pkg-notify "Install done"
}

function install_local
{
    if [ ! -d ./pkgtools.d ]; then
        echo "ERROR: no local soft to be installed"
        return 1
    fi

    if [ "$1" == "--reset" ]; then
        $PWD/pkgtools.d/pkgtool reset
    fi

    svn up
    $PWD/pkgtools.d/pkgtool check && $PWD/pkgtools.d/pkgtool configure &&
    $PWD/pkgtools.d/pkgtool build && $PWD/pkgtools.d/pkgtool build bin &&
    $PWD/pkgtools.d/pkgtool build bin_test && $PWD/pkgtools.d/pkgtool install
}

function pkgtools_manager
{
    $PKGTOOLS_ROOT/programs/pkgtools_manager --batch --with-check --with-test --update-trunk --without-doc $@ &&
    pkg-notify "Build of pkgtools_manager done"
}

