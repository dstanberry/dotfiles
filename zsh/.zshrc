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
# enable hook functions
autoload -U add-zsh-hook

# load completion function
autoload -U compinit
# Load and initialize the completion system ignoring insecure directories with a
# cache time of 20 hours, so it should almost always regenerate the first time a
# shell is opened each day.
_comp_files=(${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache(Nm-20))
if (( $#_comp_files )); then
    compinit -i -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
else
    compinit -i -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
fi
unset _comp_files

# cache completions
zstyle ':completion::complete:*' use-cache on

# enable approximate completions
# - try exact (case-sensitive) match first.
# - then fall back to case-insensitive.
# - accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' \
  '+m:{[:lower:]}={[:upper:]}' \
  '+m:{[:upper:]}={[:lower:]}' \
  '+m:{_-}={-_}' \
  'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# allow completion of ..<tab> to ../
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

# make path-directories the fallback completion order to $CDPATH
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# enable keyboard navigation of completions in menu
zstyle ':completion:*' menu select

# colorize directores and files in completion menu
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# define completion cache file location
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# define completion menu style
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green} %d (errors: %e)%f'
zstyle ':completion:*:descriptions' format ' %F{yellow} %d%f'
zstyle ':completion:*:messages' format ' %F{purple} %d%f'
zstyle ':completion:*:warnings' format ' %F{red} no matches found%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow} %d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# disable sort for git checkout completions
zstyle ':completion:*:git-checkout:*' sort false

###############################################################
# Directories
###############################################################
# adds `cdr` command for navigating to recent directories
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

# enable menu-style completion for cdr
zstyle ':completion:*:*:cdr:*:*' menu select

# fall through to cd if cdr is passed a non-recent dir as an argument
zstyle ':chpwd:*' recent-dirs-default true

# define recent-dirs cache file location
zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/chpwd-recent-dirs"

# base directory for configuration files
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# base directory for bash configuration files
BASH_CONFIG_HOME="${CONFIG_HOME}/bash"

# base directory for zsh configuration files
ZSH_CONFIG_HOME="${CONFIG_HOME}/zsh"

# base directory for tmux bash configuration files
TMUX_CONFIG_HOME="${CONFIG_HOME}/tmux"

# base directory for vim configuration files
VIM_CONFIG_HOME="${CONFIG_HOME}/vim"

# include custom defined functions
fpath=(${ZSH_CONFIG_HOME}/site-functions "${fpath[@]}")
autoload __helpers && __helpers

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

# don't record commands that begin with a space
setopt HIST_IGNORE_SPACE

# confirm history expansion
setopt HIST_VERIFY

# share history across shells
setopt SHARE_HISTORY

# remove duplicate entries from history before unique ones
setopt HIST_EXPIRE_DUPS_FIRST

# don't display duplicate entries when searching history
setopt HIST_FIND_NO_DUPS

# omit older duplicate entries that are duplicates of newer ones
setopt HIST_SAVE_NO_DUPS

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

# go to the beginning of a line
bindkey "^A" beginning-of-line
bindkey -M vicmd H vi-beginning-of-line

# go to the end of a line
bindkey "^E" end-of-line
bindkey -M vicmd L vi-end-of-line

# copy the current line
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

zle -N clear-scrollback-buffer

# add keymap to clear the buffer
bindkey '^L' clear-scrollback-buffer
bindkey '^G' clear-scrollback-buffer

# enable editing the command line using via editor
autoload -U edit-command-line
zle -N edit-command-line

# add keymap to edit command line
bindkey '^x^x' edit-command-line

# do history expansion on space
bindkey ' ' magic-space

# live grep
bindkey -s ^f "rf\n"

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

# execute the next vim command in normal mode
vi-cmd () {
  local REPLY
  # read the next keystroke, look it up in the `vicmd` keymap and, if successful,
  # evalute the widget bound to it in the context of the `vicmd` keymap.
  zle .read-command -K vicmd &&
    zle $REPLY -K vicmd
}

# make a keyboard widget out of the function above.
zle -N vi-cmd

# simulate vim's <c-o> behavior in insert mode
bindkey -v '^O' vi-cmd

# delete the word to the right of the cursor
bindkey -s '^[w' '^OcW'

# add vi-mode text-objects e.g. da" ca(
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# enable surround text-object motions
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(vi-change vi-delete)
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround

# mimic (n)vim behaviour to modify surrounding text-objects
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

###############################################################
# evalcache
###############################################################
test -s "${ZSH_CONFIG_HOME}/plugins/evalcache.zsh" \
  && source "${ZSH_CONFIG_HOME}/plugins/evalcache.zsh"

###############################################################
# Color
###############################################################
# enable dircolors if it is available
if hash vivid 2> /dev/null; then
  test -r "${CONFIG_HOME}"/vivid \
    && _evalcache echo "LS_COLORS='$(vivid generate kdark)';\nexport LS_COLORS"
elif hash dircolors 2> /dev/null; then
  test -r "${CONFIG_HOME}"/shared/dircolors \
    && _evalcache dircolors -b "${CONFIG_HOME}"/shared/dircolors \
    || _evalcache dircolors -b
fi

###############################################################
# Workspace
###############################################################
# only treat alpha-numeric strings as words
autoload -U select-word-style
select-word-style bash

# load runtime configuration files
if [ -d "$ZSH_CONFIG_HOME/rc" ]; then
  for RC_FILE in $(find "$ZSH_CONFIG_HOME"/rc -type f | sort -V); do
    case "$(basename $RC_FILE)" in
      "Path.zsh" ) _evalcache source $RC_FILE;;
      *) source "$RC_FILE";;
  esac
    done
fi

###############################################################
# Shell Prompt
###############################################################
# load prompt definitions
test -s "${ZSH_CONFIG_HOME}/prompt.zsh" \
  && source "${ZSH_CONFIG_HOME}/prompt.zsh"

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
  && export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="${ZSH_CONFIG_HOME}/plugins/highlighters" \
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

function -set-tab-and-window-title() {
  emulate -L zsh
  local CMD="${1:gs/$/\\$}"
  local TERMNAME="―― terminal"
  print -Pn "\e]0;$CMD $TERMNAME:q\a"
}

function -pwd-basename() {
  emulate -L zsh
  echo "${PWD##*/}"
}

# executed before displaying prompt.
function -update-window-title-precmd() {
  emulate -L zsh
  if [[ HISTCMD_LOCAL -eq 0 ]]; then
    # About to display prompt for the first time; nothing interesting to show in
    # the history. Show $PWD.
    -set-tab-and-window-title "$(-pwd-basename)"
  else
    local LAST=$(fc -l -1 | awk '{print $2}')
    if [ -n "$TMUX" ]; then
      # inside tmux, just show the last command: tmux will prefix it with the
      # session name (for context).
      -set-tab-and-window-title "$LAST"
    else
      # outside tmux, show $PWD (for context) followed by the last command.
      -set-tab-and-window-title "$(-pwd-basename) | $LAST"
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
  	-set-tab-and-window-title "$(-pwd-basename) > $TRIMMED"
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
  for RC_FILE in $(find "$ZSH_CONFIG_HOME"/rc.private -type f | sort -V); do
    source "$RC_FILE"
  done
fi

# kitty shell integration
if test -e "$HOME/Git/kitty/shell-integration/kitty.zsh"; then
  source "$HOME/Git/kitty/shell-integration/kitty.zsh";
fi

###############################################################
# fstab (tmpfs for WSL)
###############################################################
# ensure tmpfs is mounted
# if is_wsl; then
#   if ! mount | grep -E "^[^ ]* on /tmp " >/dev/null; then
#     sudo mount -t tmpfs tmpfs /tmp -o defaults,nodev,nosuid,noatime,size=10g
#   fi
# fi
