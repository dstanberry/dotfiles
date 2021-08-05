###############################################################
# General Options
###############################################################
# allow simple commands to resume backgrounded jobs
setopt AUTO_RESUME

# allow clobbering with >
setopt CLOBBER

# disable command auto-correction
unsetopt CORRECT

# disable argument auto-correction
unsetopt CORRECT_ALL

# disable start (c-s) and stop (c-q) characters
setopt NO_FLOW_CONTROL

# prevent accidental (c-d) from exiting shell
setopt IGNORE_EOF

# allow comments, even in interactive shells
setopt INTERACTIVE_COMMENTS

# make completion lists more densely packed
setopt LIST_PACKED

# auto-insert first possible ambiguous completion
setopt MENU_COMPLETE

# unmatched patterns are left unchanged
setopt NO_NOMATCH

# print exit status on error
setopt PRINT_EXIT_VALUE

# enable command substitution and parameter/arigthmetic expansion
setopt PROMPT_SUBST

###############################################################
# Completions
###############################################################
# load completion function
autoload -U compinit
if [ is_darwin ] && [ "$(whoami)" = "root" ]; then
  compinit -i
else
  compinit
fi

# cache completions
zstyle ':completion::complete:*' use-cache 1

# enable approximate completions
# - try exact (case-sensitive) match first.
# - then fall back to case-insensitive.
# - accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# allow completion of ..<tab> to ../
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# make path-directories the fallback completion order to $CDPATH
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# enable keyboard navigation of completions in menu
zstyle ':completion:*' menu select

###############################################################
# Directories
###############################################################
# base directory for configuration files
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# base directory for bash configuration files
BASH_CONFIG_HOME="${CONFIG_HOME}/bash"

# base directory for zsh configuration files
ZSH_CONFIG_HOME="${CONFIG_HOME}/zsh"

# base directory for tmux bash configuration files
TMUX_CONFIG_HOME="${CONFIG_HOME}/tmux"

# base directory for (n)vim configuration files
VIM_CONFIG_HOME="${CONFIG_HOME}/vim"

# include helper functions
source "${CONFIG_HOME}/scripts/helpers.sh"

# include custom defined functions
fpath=(${ZSH_CONFIG_HOME}/site-functions $fpath)

# ensure zsh cache dir exists
if [ ! -d "${HOME}"/.cache/zsh ]; then
  mkdir -p "${HOME}"/.cache/zsh
fi

# ensure that local binaries are available
if [ ! -d "${HOME}"/.local/bin ]; then
  mkdir -p "${HOME}"/.local/bin
fi

# ensure less cache dir exists
if [ ! -d "${HOME}"/.cache/less ]; then
  mkdir -p "${HOME}"/.cache/less
fi

# ensure less wrapper exists in PATH
if [ ! -L "${HOME}"/.local/bin/menos ]; then
  ln -s "${CONFIG_HOME}"/less/menos "${HOME}"/.local/bin/menos
fi

# include wsl scripts where appropriate
if is_wsl; then
  for file in "${CONFIG_HOME}"/wsl/*; do
    f=$(basename "$file")
    if [ ! -L "${HOME}"/.local/bin/"$f" ]; then
      ln -s "$file" "${HOME}"/.local/bin/"$f"
    fi
  done
fi

# ensure general purpose scripts exists in PATH
for file in "${CONFIG_HOME}"/bin/*; do
  f=$(basename "$file")
  if [ ! -L "${HOME}"/.local/bin/"$f" ]; then
    ln -s "$file" "${HOME}"/.local/bin/"$f"
  fi
done

# ensure there are no broken symlinks
find "${HOME}"/.local/bin -type l ! -exec test -e {} \; -delete

# ensure that vim packages directories exist
if [ ! -d "${VIM_CONFIG_HOME}"/remote ]; then
  mkdir -p "${VIM_CONFIG_HOME}"/remote
fi

# ensure that zsh private directories exist
if [ ! -d "${ZSH_CONFIG_HOME}"/rc.private ]; then
  mkdir -p "${ZSH_CONFIG_HOME}"/rc.private
fi

###############################################################
# History
###############################################################
# append to the history file, don't overwrite it
setopt INC_APPEND_HISTORY

# add timestamp to history
setopt EXTENDED_HISTORY

# skip any duplicates found in history during search
setopt HIST_FIND_NO_DUPS

# don't filter non-contiguous duplicates from history
setopt NO_HIST_IGNORE_ALL_DUPS

# filter contiguous duplicates from history
setopt HIST_IGNORE_DUPS

# don't record  commands that begin with a space
setopt HIST_IGNORE_SPACE

# confirm history expansion
setopt HIST_VERIFY

# share history across shells
setopt SHARE_HISTORY

# record each line as it gets issued
PROMPT_COMMAND='history -a'

# define max recording length for history
HISTSIZE=500000
HISTFILESIZE=100000

###############################################################
# Navigation
###############################################################
# prepend cd to directory names automatically
setopt AUTO_CD

# tab completing a directory
setopt AUTO_PARAM_SLASH

# automatically push old dir unto dir stack
setopt AUTO_PUSHD

# don't push multiple copies of same dir onto stack
setopt PUSHD_IGNORE_DUPS

# don't print dir stack after pushing/popping
setopt PUSHD_SILENT

# enable vi style keybinds
bindkey -v

# use emacs style keybind to go to the beginning/end of a line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# use emacs style keybind to copy the current line
bindkey -M viins "^Y" yank

# use "cbt" capability ("back_tab", as per `man terminfo`), if we have it:
if tput cbt &> /dev/null; then
  # make Shift-tab go to previous completion
  bindkey "$(tput cbt)" reverse-menu-complete
fi

# enable advancing to the next/previous word in a command
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# delete character when delete key is pressed
bindkey "^[[3~" vi-delete-char
bindkey "^[3;5~" delete-char

# add ability to clear the buffer
function clear-scrollback-buffer() {
  # clear screen
  clear
  # clear buffer. The following sequence code is available for xterm.
  printf '\e[3J'
  # .reset-prompt: bypass the zsh-syntax-highlighting wrapper
  # https://github.com/sorin-ionescu/prezto/issues/1026
  # https://github.com/zsh-users/zsh-autosuggestions/issues/107#issuecomment-183824034
  # -R: redisplay the prompt to avoid old prompts being eaten up
  # https://github.com/Powerlevel9k/powerlevel9k/pull/1176#discussion_r299303453
  zle .reset-prompt && zle -R
}

# add keymap to clear the buffer
zle -N clear-scrollback-buffer
bindkey '^L' clear-scrollback-buffer

# enable editing the command line using via editor
autoload -U edit-command-line
zle -N edit-command-line

# add keymap to edit command line
bindkey '^x^x' edit-command-line

# do history expansion on space
bindkey ' ' magic-space

# make (c-z) toggle between bg and fg for processes
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}

# add keymap to toggle fg/bg process
zle -N fg-bg
bindkey '^Z' fg-bg

###############################################################
# Color
###############################################################
# enable dircolors if it is available
if hash dircolors 2> /dev/null; then
  test -r "${CONFIG_HOME}"/shared/dircolors \
    && eval "$(dircolors -b "${CONFIG_HOME}"/shared/dircolors)" \
    || eval "$(dircolors -b)"
fi

###############################################################
# Workspace
###############################################################
# only treat alpha-numeric strings as words
autoload -U select-word-style
select-word-style bash

# load runtime configuration files
if [ -d "$ZSH_CONFIG_HOME/rc" ]; then
  for RC_FILE in $(find "$ZSH_CONFIG_HOME"/rc -type f | sort); do
    source "$RC_FILE"
  done
fi

###############################################################
# Shell Prompt
###############################################################
# load prompt definitions
test -s "${ZSH_CONFIG_HOME}/prompt.zsh" \
  && source "${ZSH_CONFIG_HOME}/prompt.zsh"

###############################################################
# fzf
###############################################################
if hash fzf 2> /dev/null; then
  # load fzf keybinds
  test -s "${ZSH_CONFIG_HOME}/plugins/fzf/key-bindings.zsh" \
    && source "${ZSH_CONFIG_HOME}/plugins/fzf/key-bindings.zsh"

  # load fzf completion
  test -s "${ZSH_CONFIG_HOME}/plugins/fzf/completion.zsh" \
    && source "${ZSH_CONFIG_HOME}/plugins/fzf/completion.zsh"

  autoload _fzf
  _fzf
fi

###############################################################
# zsh-autosuggestions
###############################################################
test -s "${ZSH_CONFIG_HOME}/plugins/zsh-autosuggestions.zsh" \
  && source "${ZSH_CONFIG_HOME}/plugins/zsh-autosuggestions.zsh" \
  && ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

###############################################################
# zsh-syntax-highlighting
###############################################################
test -s "${ZSH_CONFIG_HOME}/plugins/zsh-syntax-highlighting.zsh" \
  && source "${ZSH_CONFIG_HOME}/plugins/zsh-syntax-highlighting.zsh"

###############################################################
# zsh-history-substring-search
###############################################################
test -s "${ZSH_CONFIG_HOME}/plugins/zsh-history-substring-search.zsh" \
  && source "${ZSH_CONFIG_HOME}/plugins/zsh-history-substring-search.zsh" \
  && HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# enable incremental history search with up/down arrows
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

###############################################################
# Hooks
###############################################################
# local hash table for storing variables
typeset -A __HTABLE

# track the number of commands local to this shell
HISTCMD_LOCAL=0

# enable hook functions
autoload -U add-zsh-hook

function -set-tab-and-window-title() {
  emulate -L zsh
  local CMD="${1:gs/$/\\$}"
  local TERMNAME="―― terminal"
  print -Pn "\e]0;$CMD $TERMNAME:q\a"
}

# executed before displaying prompt.
function -update-window-title-precmd() {
  emulate -L zsh
  if [[ HISTCMD_LOCAL -eq 0 ]]; then
    # About to display prompt for the first time; nothing interesting to show in
    # the history. Show $PWD.
    -set-tab-and-window-title "$(basename "$PWD")"
  else
    local LAST=$(history | tail -1 | awk '{print $2}')
    if [ -n "$TMUX" ]; then
      # inside tmux, just show the last command: tmux will prefix it with the
      # session name (for context).
      -set-tab-and-window-title "$LAST"
    else
      # outside tmux, show $PWD (for context) followed by the last command.
      -set-tab-and-window-title "$(basename "$PWD") | $LAST"
    fi
  fi
}

add-zsh-hook precmd -update-window-title-precmd

# executed before executing a command: $2 is one-line (truncated) version of
# the command.
function -update-window-title-preexec() {
  emulate -L zsh
  setopt EXTENDED_GLOB
  HISTCMD_LOCAL=$((++HISTCMD_LOCAL))

  # skip ENV=settings, sudo, ssh; show first distinctive word of command;
  # mostly stolen from:
  # https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
  local TRIMMED=${2[(wr)^(*=*|mosh|ssh|sudo)]}
  if [ -n "$TMUX" ]; then
  	# inside tmux, show the running command: tmux will prefix it with the
  	# session name (for context).
  	-set-tab-and-window-title "$TRIMMED"
  else
  	# outside tmux, show $PWD (for context) followed by the running command.
  	-set-tab-and-window-title "$(basename $PWD) > $TRIMMED"
  fi
}

add-zsh-hook preexec -update-window-title-preexec

function -auto-ls-after-cd() {
  emulate -L zsh
  # only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    setopt nullglob
    ls -a
  fi
}

add-zsh-hook chpwd -auto-ls-after-cd

# remember each command we run.
function -record-command() {
  __HTABLE[LAST_COMMAND]="$2"
}

add-zsh-hook preexec -record-command

###############################################################
# _Custom
###############################################################
# check for machine-specific rc files and source them if available
if [ -d "$ZSH_CONFIG_HOME/rc.private" ]; then
  for RC_FILE in $(find "$ZSH_CONFIG_HOME"/rc.private -type f | sort); do
    source "$RC_FILE"
  done
fi

###############################################################
# Tmux
###############################################################
# check if inside tmux session
_not_inside_tmux() { [[ -z "$TMUX" ]] }

# create tmux session
ensure_tmux_is_running() {
  if _not_inside_tmux; then
    tat
  fi
}

# don't launch tmux for remote sessions
launch=true
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  launch=false
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) launch=false;;
  esac
fi
if [[ "$launch" = true ]]; then
  ensure_tmux_is_running
fi
