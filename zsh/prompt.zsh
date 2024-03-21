###############################################################
# Shell Prompt
###############################################################
# load colors function
autoload -U colors
colors

if [ -f "$CONFIG_HOME/zsh/site-functions/async" ]; then
  # load version tracking function
  autoload -Uz vcs_info

  # define vcs parameters for git
  zstyle ':vcs_info:*' enable git
  () {
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr "%F{green}▪%f"
    zstyle ':vcs_info:*' unstagedstr "%F{red}▪%f"
    zstyle ':vcs_info:*' use-simple true
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stash git-compare git-remotebranch
    zstyle ':vcs_info:git*:*' formats '%F{cyan} %b%m%c%u%f '
    zstyle ':vcs_info:git*:*' actionformats '%B%F{red} %b|%a %8.8i%c%u %f'

    __in_git() {
      [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]
    }

    # show untracked status in git prompt
    function +vi-git-untracked() {
      emulate -L zsh
      if __in_git; then
        if [[ -n $(git ls-files --directory --no-empty-directory --exclude-standard --others 2> /dev/null) ]]; then
          hook_com[unstaged]+="%F{blue}▪%f"
        fi
      fi
    }

    # show stashes in git prompt
    function +vi-git-stash() {
      local stash_icon="󰋻"
      emulate -L zsh
      if __in_git; then
        if [[ -n $(git rev-list --walk-reflogs --count refs/stash 2> /dev/null) ]]; then
          hook_com[unstaged]+=" %F{yellow}$stash_icon%f "
        fi
      fi
    }

    # show metrics local branch is ahead-of or behind remote HEAD.
    function +vi-git-compare() {
      local ahead behind
      local -a gitstatus
      git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0
      local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
      )
      ahead=${ahead_and_behind[1]}
      behind=${ahead_and_behind[2]}
      local ahead_symbol="%{$fg[red]%}⇡%{$reset_color%}${ahead}"
      local behind_symbol="%{$fg[cyan]%}⇣%{$reset_color%}${behind}"
      (( $ahead )) && gitstatus+=( "${ahead_symbol}" )
      (( $behind )) && gitstatus+=( "${behind_symbol}" )
      hook_com[misc]+="${(j: :)gitstatus}"
    }

    # show remote branch name for remote-tracking branches
    function +vi-git-remotebranch() {
      local remote
      remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
      # if [[ -n ${remote} ]] ; then
      if [[ -n ${remote} && ${remote#*/} != ${hook_com[branch]} ]] ; then
        hook_com[branch]="${hook_com[branch]}→[${remote}]"
      fi
    }
  }

  # load async function
  autoload -Uz async && async
  # source $CONFIG_HOME/zsh/site-functions/async

  # register async worker
  -start-async-vcs-info-worker() {
    async_start_worker vcs_info
    async_register_callback vcs_info -async-vcs-info-callback
  }

  # wrapper to print vcs information
  -get-vcs-info-job() {
    cd -q $1
    vcs_info
    print ${vcs_info_msg_0_}
  }

  # callback when vcs information is ready
  -async-vcs-info-callback() {
    local job=$1
    local return_code=$2
    local stdout=$3
    local more=$6
    if [[ $job == '[async]' ]]; then
      if [[ $return_code -eq 1 ]]; then
        # 1 = corrupt worker output
        return
      elif [[ $return_code -eq 2 || $return_code -eq 3 || $return_code -eq 130 ]]; then
        # 2 = zle watcher detected an error on the worker fd
        # 3 = response from async_job when worker is missing
        # 130 = async worker crashed, this should not happen but it can mean the file descriptor has become corrupt
        #
        # restart worker.
        async_stop_worker vcs_info
        -start-async-vcs-info-worker
        return
      fi
    fi
    vcs_info_msg_0_=$stdout
    # -update-rprompt "\${vcs_info_msg_0_}%F"
    (( $more )) || zle reset-prompt
  }

  # schedule worker to get vcs information
  -vcs-info-run-in-worker() {
    async_flush_jobs vcs_info
    async_job vcs_info -get-vcs-info-job $PWD
  }

  # reset vcs information when PWD changes
  -clear-vcs-info-on-chpwd() {
    vcs_info_msg_0_=
  }

  # iniitialize async worker for vcs-info
  # async_init
  -start-async-vcs-info-worker

  add-zsh-hook precmd -vcs-info-run-in-worker
  add-zsh-hook chpwd -clear-vcs-info-on-chpwd

  RPROMPT_VCS="\${vcs_info_msg_0_}"
else
  RPROMPT_VCS=""
fi

# (lhs) update the prompt
function -update-prompt() {
  # check for tmux by looking at $TERM, because $TMUX won't be propagated to any
  # nested sudo shells but $TERM will.
  local TMUXING=$([[ "$TERM" =~ "tmux" ]] && echo tmux)
  if [ -n "$TMUXING" -a -n "$TMUX" ]; then
    # in a tmux session created in a non-root or root shell.
    local LVL=$(($SHLVL - 1))
  elif [ -n "$TMUX" ]; then
    # in a tmux session created in a non-root shell
    local LVL=$(($SHLVL - 1))
  else
    # either in a root shell created inside a non-root tmux session,
    # or not in a tmux session.
    local LVL=$SHLVL
  fi
  # check if current context is within python virtual environment
  local VIRTENV=""
  if [ -n "$VIRTUAL_ENV" ]; then
    local VIRTENV="%F{yellow}$(echo '('`basename $VIRTUAL_ENV`')')%f "
  fi
  if [[ $EUID -eq 0 ]]; then
    local PREFIX="%F{red}󰒃%f ${VIRTENV}"
  else
    local PREFIX="${VIRTENV}"
  fi
  local mode=$1
  if [[ $mode == insert ]]; then
    local SUFFIX=$(printf '%%F{green}%%(?..%%F{red})❯%.0s%%f' {1..$LVL})
  else
    local SUFFIX=$(printf '%%F{magenta}❯%.0s%%f' {1..$LVL})
  fi

  # define the primary prompt
  PS1="${PREFIX}%F{green}${SSH_TTY:+%m}%f%B${SSH_TTY:+ }%F{blue}%B%1~ %b%f%B${SUFFIX}%b "

  if [[ -n "$TMUXING" ]]; then
    # outside tmux, ZLE_RPROMPT_INDENT ends up eating the space after PS1, and
    # prompt still gets corrupted even if we add an extra space to compensate.
    export ZLE_RPROMPT_INDENT=0
  fi
}

# set the cursor shape depending on current vi mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    -update-prompt normal
  else
    -update-prompt insert
  fi
  zle reset-prompt
}

zle -N zle-keymap-select

# block cursor
function -set-block-cursor() {
  echo -ne "\e[0 q\e[2 q\e]12;gray\a"
}

# begin the line editor in vi insert mode on startup
function zle-line-init() {
  zle -K viins
  -update-prompt insert
  -set-block-cursor
  zle reset-prompt
}

zle -N zle-line-init

typeset -F SECONDS

function -record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

add-zsh-hook preexec -record-start-time

# (rhs) update the prompt
function -update-rprompt() {
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
    export RPROMPT="$RPROMPT_VCS $@%F{244}${ELAPSED}%f"
    unset ZSH_START_TIME
  else
    export RPROMPT="$RPROMPT_VCS"
  fi
}

add-zsh-hook precmd -update-rprompt
