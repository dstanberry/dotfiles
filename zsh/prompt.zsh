###############################################################
# Shell Prompt
###############################################################
# load add-zsh-hook
autoload -U add-zsh-hook

# load colors function
autoload -U colors
colors

# load async function
autoload -Uz async && async

# register async worker
-vcs_info_async() {
  async_start_worker vcs_info
  async_register_callback vcs_info -vcs_info_callback
}

# wrapper to print vcs information
-vcs_info_worker() {
  cd -q $1
  vcs_info
  print ${vcs_info_msg_0_}
}

# callback when vcs information is ready
-vcs_info_callback() {
  local job=$1
  local return_code=$2
  local stdout=$3
  local more=$6
  if [[ $job == '[async]' ]]; then
    if [[ $return_code -eq 2 ]]; then
      -vcs_info_async
      return
    fi
  fi
  vcs_info_msg_0_=$stdout
  -report-start-time "\${vcs_info_msg_0_}%F"
  [[ $more == 1 ]] || zle reset-prompt
}

# schedule worker to get vcs information
-vcs_info_precmd() {
  retval=$?
  async_flush_jobs vcs_info
  async_job vcs_info -vcs_info_worker $PWD
}

add-zsh-hook precmd -vcs_info_precmd

# reset vcs information when PWD changes
-vcs_info_chpwd() {
  vcs_info_msg_0_=
}

add-zsh-hook chpwd -vcs_info_chpwd

# load version tracking function
autoload -Uz vcs_info

# define vcs parameters for git
zstyle ':vcs_info:*' enable git
() {
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr "%F{green}●%f"
  zstyle ':vcs_info:*' unstagedstr "%F{red}●%f"
  zstyle ':vcs_info:*' use-simple true
  zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
  zstyle ':vcs_info:git*:*' formats '%F{cyan} %b%m%c%u%f '
  zstyle ':vcs_info:git*:*' actionformats '%F{cyan} %b|%a%m%c%u %f'

  # show untracked status in git prompt
  function +vi-git-untracked() {
    emulate -L zsh
    if [ $(git rev-parse --is-inside-work-tree 2> /dev/null) = true ] && \
      git status --porcelain | grep '??' &> /dev/null ; then
      hook_com[unstaged]+="%F{blue}●%f"
    fi
  }
}

# iniitialize async worker
-vcs_info_async

function -set-prompt() {
  # check for tmux by looking at $TERM, because $TMUX won't be propagated to any
  # nested sudo shells but $TERM will.
  local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    # in a a tmux session created in a non-root or root shell.
    local LVL=$(($SHLVL - 1))
  else
    # either in a root shell created inside a non-root tmux session,
    # or not in a tmux session.
    local LVL=$SHLVL
  fi
  if [[ $EUID -eq 0 ]]; then
    local PREFIX=$(printf '%%F{red}%.0s%%f ')
  else
    local PREFIX=''
  fi
  local mode=$1
  if [[ $mode == insert ]]; then
    if [[ $retval -eq 0 ]]; then
      local SUFFIX=$(printf '%%F{green}❯%.0s%%f' {1..$LVL})
    else
      local SUFFIX=$(printf '%%F{red}❯%.0s%%f' {1..$LVL})
    fi
  else
    local SUFFIX=$(printf '%%F{magenta}❯%.0s%%f' {1..$LVL})
  fi

  # define the primary prompt
  PS1="${PREFIX}%F{green}${SSH_TTY:+%m}%f%B${SSH_TTY:+ }%F{blue}%B%3~ %b%f%B${SUFFIX}%b "

  if [[ -n "$TMUXING" ]]; then
    # outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
    # prompt still gets corrupted even if we add an extra space to compensate.
    export ZLE_RPROMPT_INDENT=0
  fi
}

typeset -F SECONDS

function -record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

add-zsh-hook preexec -record-start-time

function -report-start-time() {
  emulate -L zsh
  if [ "$ZSH_START_TIME" ]; then
    local DELTA=$((SECONDS - ZSH_START_TIME))
    local DAYS=$((~~(DELTA / 86400)))
    local HOURS=$((~~((DELTA - DAYS * 86400) / 3600)))
    local MINUTES=$((~~((DELTA - DAYS * 86400 - HOURS * 3600) / 60)))
    local SECS=$((DELTA - DAYS * 86400 - HOURS * 3600 - MINUTES * 60))
    local ELAPSED=''
    test "$DAYS" != '0' && ELAPSED="${DAYS}d"
    test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
    test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
    if [ "$ELAPSED" = '' ]; then
      SECS="$(print -f "%.2f" $SECS)s"
    elif [ "$DAYS" != '0' ]; then
      SECS=''
    else
      SECS="$((~~SECS))s"
    fi
    ELAPSED="${ELAPSED}${SECS}"
    export RPROMPT="$@ %F{244}${ELAPSED}%f"
    unset ZSH_START_TIME
  else
    export RPROMPT=""
  fi
}

# don't trigger spell check on dotfiles
export CORRECT_IGNORE_FILE='.*'

# save executed commands to global variable instead of histfile
function zshaddhistory() {
  LASTHIST=$1
  return 2
}

# add last executed command to histfile if return code is 0
function precmd() {
  if [[ $? == 0 && -n $LASTHIST && -n $HISTFILE ]] ; then
    print -sr -- ${=${LASTHIST%%'\n'}}
  fi
}

# change cursor shape
function -set-cursor() {
  if [[ $TMUX = '' ]]; then
    echo -ne $1
  else
    echo -ne "\ePtmux;\e\e$1\e\\"
  fi
}

# block cursor
function -set-block-cursor() {
  -set-cursor '\e[2 q'
}

# beam cursor
function -set-beam-cursor() {
  -set-cursor '\e[5 q'
}

# set the cursor shape depending on current vi mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    -set-prompt normal
  else
    -set-prompt insert
  fi
  zle reset-prompt
}

zle -N zle-keymap-select

# begin the line editor in vi insert mode on startup
function zle-line-init() {
  zle -K viins
  -set-prompt insert
  -set-block-cursor
  zle reset-prompt
}

zle -N zle-line-init
