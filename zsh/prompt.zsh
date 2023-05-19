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

# block cursor
function -set-block-cursor() {
  echo -ne "\e[0 q\e[2 q\e]12;gray\a"
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
