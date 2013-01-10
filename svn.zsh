# -*- mode: shell-script; -*-
function svn_prompt_info {
    if [ $(in_svn) ]; then
        echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$(svn_get_repo_name)$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR$(svn_dirty)$ZSH_PROMPT_BASE_COLOR"
    fi
}


function in_svn() {
    if [[ -d .svn ]]; then
        echo 1
    fi
}

function svn_get_repo_name {
    if [ $(in_svn) ]; then
        # LC_MESSAGES=en_GB svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
        # LC_MESSAGES=en_GB svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p" | sed "s/\/.*$//"
        info=$(LC_MESSAGES=en_GB svn info)
        repo=$(echo ${info} | sed -n 's/URL:\ .*\///p')
        rev=$(echo ${info} | sed -n 's/Revision:\ //p')
        echo "${repo}|${rev}"
    fi
}

function svn_get_rev_nr {
    if [ $(in_svn) ]; then
        svn info 2> /dev/null | sed -n s/Revision:\ //p
    fi
}

function svn_dirty_choose {
    if [ $(in_svn) ]; then
        s=$(svn status|grep -E '^\s*[ACDIM!L]' 2>/dev/null)
        if [ $s ]; then
            echo $1
        else
            echo $2
        fi
    fi
}

function svn_dirty {
    svn_dirty_choose $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}

function svnstatus () {
 templist=`svn status $*`
 echo `echo $templist | grep '^?' | wc -l` unversioned files/directories
 echo $templist | grep -v '^?'
}

#export C2C=$(which code2color)
function svndiff {
 svn diff $* | code2color -l patch -
}