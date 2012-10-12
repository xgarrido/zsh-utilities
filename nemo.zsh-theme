# -*- mode: shell-script; -*-
# the svn plugin has to be activated for this to work.
ZSH_THEME_NEMO_USE_POWERLINE=0

if [ -n "${SNAILWARE_SETUP_DONE}" ]; then
    ZSH_THEME_NEMO_SETUP="snailware/${SNAILWARE_SOFTWARE_VERSION}@"
fi
if [ "$TERM" = "eterm-color" ]; then
    ZSH_THEME_NEMO_HOSTNAME=$FX[bold]$fg[green]
    ZSH_THEME_NEMO_DIRECTORY=$fg[green]
        # Redefine color for ls
    export LS_COLORS='di=33:ex=31'
else
    case "$HOSTNAME" in
        garrido-laptop)
            ZSH_THEME_NEMO_USE_POWERLINE=1
            ZSH_THEME_NEMO_HOSTNAME=$fg[blue]
            ZSH_THEME_NEMO_TIME=$fg[red]

            POWERLINE_COLOR_BG_GRAY1=$BG[237]
            POWERLINE_COLOR_BG_GRAY2=$BG[245]
            POWERLINE_COLOR_BG_GRAY3=

            POWERLINE_COLOR_FG_GRAY1=$FG[237]
            POWERLINE_COLOR_FG_GRAY2=$FG[245]
            POWERLINE_COLOR_FG_GRAY3=$FG[235]
            POWERLINE_COLOR_FG_WHITE1=$FG[255]
            POWERLINE_COLOR_FG_WHITE2=$FG[255]
            ;;
        pc-91089)
            ZSH_THEME_NEMO_HOSTNAME=$fg[blue]
            ZSH_THEME_NEMO_TIME=$FG[013]

            ZSH_THEME_NEMO_USE_POWERLINE=1
            POWERLINE_COLOR_BG_GRAY1=$bg[blue]
            POWERLINE_COLOR_BG_GRAY2=$BG[013]
            POWERLINE_COLOR_BG_GRAY3=

            POWERLINE_COLOR_FG_GRAY1=$fg[blue]
            POWERLINE_COLOR_FG_GRAY2=$FG[013]
            POWERLINE_COLOR_FG_WHITE1=$FG[255]
            POWERLINE_COLOR_FG_WHITE2=$FG[255]
            ;;
        lx*.lal.in2p3.fr|nemo*.lal.in2p3.fr)
            ZSH_THEME_NEMO_HOSTNAME_SUFFIX=
            ZSH_THEME_NEMO_HOSTNAME=$FG[184]
            ZSH_THEME_NEMO_TIME=$fg[green]

            ZSH_THEME_NEMO_USE_POWERLINE=0
            POWERLINE_COLOR_BG_GRAY1=$BG[184]
            POWERLINE_COLOR_BG_GRAY2=$bg[green]
            POWERLINE_COLOR_BG_GRAY3=

            POWERLINE_COLOR_FG_GRAY1=$FG[184]
            POWERLINE_COLOR_FG_GRAY2=$fg[green]
            POWERLINE_COLOR_FG_GRAY3=$FG[235]
            POWERLINE_COLOR_FG_WHITE1=$fg[green]
            POWERLINE_COLOR_FG_WHITE2=$FG[184]
            ;;
        ccige*|ccage*)
            ZSH_THEME_NEMO_HOSTNAME_SUFFIX=
            ZSH_THEME_NEMO_HOSTNAME=$FG[012]
            ZSH_THEME_NEMO_TIME=$FG[005]

            ZSH_THEME_NEMO_USE_POWERLINE=0
            POWERLINE_COLOR_BG_GRAY1=$BG[012]
            POWERLINE_COLOR_BG_GRAY2=$BG[005]
            POWERLINE_COLOR_BG_GRAY3=

            POWERLINE_COLOR_FG_GRAY1=$FG[012]
            POWERLINE_COLOR_FG_GRAY2=$FG[005]
            POWERLINE_COLOR_FG_GRAY3=$FG[005]
            POWERLINE_COLOR_FG_WHITE1=$FG[005]
            POWERLINE_COLOR_FG_WHITE2=$FG[012]

            ;;
    esac
fi

ZSH_THEME_GIT_PROMPT_PREFIX="git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=") ✘ "
ZSH_THEME_GIT_PROMPT_CLEAN=") ✔ "

ZSH_THEME_SVN_PROMPT_PREFIX="svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX=""
ZSH_THEME_SVN_PROMPT_DIRTY=") ✘ "
ZSH_THEME_SVN_PROMPT_CLEAN=") ✔ "

if [ "$ZSH_THEME_NEMO_USE_POWERLINE" = "1" ]; then

    PROMPT='
'%{$POWERLINE_COLOR_BG_GRAY1%}%{$POWERLINE_COLOR_FG_WHITE1%}' '%T' '%{$reset_color%}%{$POWERLINE_COLOR_FG_GRAY1%}%{$POWERLINE_COLOR_BG_GRAY2%}$'\u2b80'%{$reset_color%}%{$POWERLINE_COLOR_FG_WHITE2%}%{$POWERLINE_COLOR_BG_GRAY2%}' ${ZSH_THEME_NEMO_SETUP}${HOSTNAME} '%{$reset_color%}%{$POWERLINE_COLOR_FG_GRAY2%}%{$POWERLINE_COLOR_BG_GRAY3%}$'\u2b80'%{$reset_color%}' ${PWD/#$HOME/~}
➜  '

# ➜  '
    if [[ "$HOSTNAME" = "garrido-laptop" || "$HOSTNAME" = "pc-91089" ]]; then
        RPROMPT=%{$POWERLINE_COLOR_FG_GRAY1%}$'\u2b82%{$reset_color%}%{$POWERLINE_COLOR_BG_GRAY1%}%{$POWERLINE_COLOR_FG_WHITE1%} $(git_prompt_info)$(svn_prompt_info)%{$reset_color%}'
    fi

else
    PROMPT='%{${ZSH_THEME_NEMO_TIME}%}%T %{$ZSH_THEME_NEMO_HOSTNAME_SUFFIX%}%{$ZSH_THEME_NEMO_HOSTNAME%}${ZSH_THEME_NEMO_SETUP}${HOSTNAME} %{${ZSH_THEME_NEMO_HOSTNAME}%}${PWD/#$HOME/~}%{$reset_color%}
%{${ZSH_THEME_NEMO_HOSTNAME}%}$ %{$reset_color%}'


#     PROMPT='%{$POWERLINE_COLOR_FG_GRAY2%}%T %{$ZSH_THEME_NEMO_HOSTNAME_SUFFIX$POWERLINE_COLOR_FG_GRAY1%}${ZSH_THEME_NEMO_SETUP}${HOSTNAME}$FX[reset] %{$POWERLINE_COLOR_FG_GRAY2%}${PWD/#$HOME/~}
# %{$POWERLINE_COLOR_FG_GRAY2%}$ %{$reset_color%}'
    if [[ "$HOSTNAME" = "garrido-laptop" || "$HOSTNAME" = "pc-91089" ]]; then
        RPROMPT='%{${ZSH_THEME_NEMO_HOSTNAME}%}$(git_prompt_info)%{${ZSH_THEME_NEMO_HOSTNAME}%}$(svn_prompt_info)%{$reset_color%}'
        #RPROMPT='%{${ZSH_THEME_NEMO_DIRECTORY}%}$(git_prompt_info)%{${ZSH_THEME_NEMO_DIRECTORY}%}$(svn_prompt_info)%{$reset_color%}'
    fi
fi
