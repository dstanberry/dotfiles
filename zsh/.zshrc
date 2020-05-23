###############################################################
# Environment Variables
###############################################################
# helper functions to trim duplicate occurences from a string
get_var () {
	eval 'printf "%s\n" "${'"$1"'}"'
}

set_var () {
	eval "$1=\"\$2\""
}

dedup_pathvar () {
	pathvar_name="$1"
	pathvar_value="$(get_var "$pathvar_name")"
	deduped_path="$(perl -e 'print join(":",grep { not $seen{$_}++ } split(/:/, $ARGV[0]))' "$pathvar_value")"
	set_var "$pathvar_name" "$deduped_path"
}

# base directory for user local binaries
LOCAL="${HOME}/.local/bin"

# include directory in PATH
test -s "${LOCAL}" && \
export PATH=$PATH:$LOCAL

# ensure no duplicate entries are present in PATH
dedup_pathvar PATH

###############################################################
# General Options
###############################################################
# allow simple commands to resume backgrounded jobs
setopt AUTO_RESUME

# allow clobbering with >
setopt CLOBBER

# enable command auto-correction
setopt CORRECT

# enable argument auto-correction
setopt CORRECT_ALL

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
compinit

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

# base directory forim configuration files
VIM_CONFIG_HOME="${CONFIG_HOME}/vim"

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

# use standard ISO 8601 timestamp
export HISTTIMEFORMAT='%F %T '

# ignore commands that have no forensicalue
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# define history file location
export HISTFILE="${ZSH_CONFIG_HOME}/zsh_history"

# save the history
export SAVEHIST=$HISTSIZE

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

# emacs bindings, set to -v for vi bindings
bindkey -e

# use "cbt" capability ("back_tab", as per `man terminfo`), if we have it:
if tput cbt &> /dev/null; then
	bindkey "$(tput cbt)" reverse-menu-complete # make Shift-tab go to previous completion
fi

# enable incremental history search with up/down arrows
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# add ability to clear the buffer
function clear-scrollback-buffer {
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
# enable true color support
export TERM=xterm-256color

# enable syntax highlighting for less
export LESS="-iFMRX"
export LESSCOLOR=always
export LESSCOLORIZER=/usr/bin/src-hilite-lesspipe.sh

# set location for less history file
export LESSHISTFILE="${CONFIG_HOME}/less/less_history"

# enable dircolors if it is available
if hash dircolors 2>/dev/null; then
	test -r ${BASH_CONFIG_HOME}/dircolors && \
	eval "$(dircolors -b ${BASH_CONFIG_HOME}/dircolors)" \
	|| eval "$(dircolors -b)"

	# enable color support for ls
	alias ls='ls --color=auto --almost-all'
	# enable color support for grep
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# wrap diff commands and colorize the output
hash colordiff 2>/dev/null && alias diff=colordiff

###############################################################
# Workspace
###############################################################
# set the default editor
export EDITOR=/usr/bin/vim

# set location forim runtime configuration
export MYVIMRC="${VIM_CONFIG_HOME}/vimrc"
__viminit=":set runtimepath+=${VIM_CONFIG_HOME},"
__viminit+="${VIM_CONFIG_HOME}/after"
__viminit+="|set viminfo='10,\\\"100,:20,%,n${VIM_CONFIG_HOME}/viminfo"
__viminit+="|:source ${MYVIMRC}"
__viminit+="|:set runtimepath+=${VIM_CONFIG_HOME},"
__viminit+="${VIM_CONFIG_HOME}/after"
export VIMINIT=$__viminit
unset __viminit

# set location for tmux runtime configuration
hash tmux 2>/dev/null && alias tmux='tmux -f "${TMUX_CONFIG_HOME}/tmux.conf"'

# define alias to reload zsh configuration
alias reload='source "${ZSH_CONFIG_HOME}/.zshrc"'

autoload -U select-word-style
select-word-style bash

###############################################################
# Shell Prompt
###############################################################
# load prompt definitions
test -s "${ZSH_CONFIG_HOME}/prompt.zsh" && \
source "${ZSH_CONFIG_HOME}/prompt.zsh"

###############################################################
# fzf
###############################################################
if hash fzf 2>/dev/null; then
	# load fzf keybinds
	test -s "${ZSH_CONFIG_HOME}/plugins/fzf" && \
	source "${ZSH_CONFIG_HOME}/plugins/fzf"

	# Use ~~ as the trigger sequence instead of the default **
	export FZF_COMPLETION_TRIGGER='?'

	# set fd as the default source for fzf
	export FZF_DEFAULT_COMMAND='fd -HI --hidden --follow --type file --color=always'
	export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

	# define default options for fzf
	if test -x `which bat`; then
		__fzf_preview_opts="--ansi --preview-window 'right:60%' "
		__fzf_preview_opts+="--preview 'bat --color=always "
		__fzf_preview_opts+="--style=header,grid --line-range :300 {}'"
		export FZF_DEFAULT_OPTS=$__fzf_preview_opts
		unset __fzf_preview_opts
	fi

	export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
	 --color=dark
	 --color=fg:#bebebe,bg:-1,hl:#a3be8c
	 --color=fg+:#e7ebf1,bg+:-1,hl+:#a3be8c
	 --color=info:#4c566a,prompt:#81a1c1,pointer:#bf616a
	 --color=marker:#ebcb8b,spinner:#4c566a,header:#5f5f5f'
fi

###############################################################
# bat
###############################################################
# define configuration path for bat
if hash bat 2>/dev/null; then
	export BAT_CONFIG_PATH="${CONFIG_HOME}/bat/bat.conf"
fi

###############################################################
# zsh-autosuggestions
###############################################################
test -s "${ZSH_CONFIG_HOME}/plugins/zsh-autosuggestions.zsh" && \
source "${ZSH_CONFIG_HOME}/plugins/zsh-autosuggestions.zsh" && \
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

###############################################################
# zsh-history-substring-search
###############################################################
test -s "${ZSH_CONFIG_HOME}/plugins/zsh-history-substring-search.zsh" && \
source "${ZSH_CONFIG_HOME}/plugins/zsh-history-substring-search.zsh" && \
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

###############################################################
# zsh-syntax-highlighting
###############################################################
test -s "${ZSH_CONFIG_HOME}/plugins/zsh-syntax-highlighting.zsh" && \
source "${ZSH_CONFIG_HOME}/plugins/zsh-syntax-highlighting.zsh"

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
	print -Pn "\e]0;$CMD:q\a"
}

# executed before displaying prompt.
function -update-window-title-precmd() {
	emulate -L zsh
	if [[ HISTCMD_LOCAL -eq 0 ]]; then
		# About to display prompt for the first time; nothing interesting to show in
		# the history. Show $PWD.
		-set-tab-and-window-title "$(basename $PWD)"
	else
		local LAST=$(history | tail -1 | awk '{print $2}')
		if [ -n "$TMUX" ]; then
			# inside tmux, just show the last command: tmux will prefix it with the
			# session name (for context).
			-set-tab-and-window-title "$LAST"
		else
			# outside tmux, show $PWD (for context) followed by the last command.
			-set-tab-and-window-title "$(basename $PWD) > $LAST"
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
	local TRIMMED="${2[(wr)^(*=*|mosh|ssh|sudo)]}"
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

typeset -F SECONDS

function -record-start-time() {
	emulate -L zsh
	ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

add-zsh-hook preexec -record-start-time

function -report-start-time() {
	emulate -L zsh
	if [ $ZSH_START_TIME ]; then
		local DELTA=$(($SECONDS - $ZSH_START_TIME))
		local DAYS=$((~~($DELTA / 86400)))
		local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
		local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
		local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
		local ELAPSED=''
		test "$DAYS" != '0' && ELAPSED="${DAYS}d"
		test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
		test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
		if [ "$ELAPSED" = '' ]; then
			SECS="$(print -f "%.2f" $SECS)s"
		elif [ "$DAYS" != '0' ]; then
			SECS=''
		else
			SECS="$((~~$SECS))s"
		fi
		ELAPSED="${ELAPSED}${SECS}"
		export RPROMPT="%F{cyan}${ELAPSED}%f"
		unset ZSH_START_TIME
	else
		export RPROMPT=""
	fi
}

add-zsh-hook precmd -report-start-time

function -auto-ls-after-cd() {
	emulate -L zsh
	# only in response to a user-initiated `cd`, not indirectly (eg. via another
	# function).
	if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
		ls -a
	fi
}

add-zsh-hook chpwd -auto-ls-after-cd

# remember each command we run.
function -record-command() {
	__HTABLE[LAST_COMMAND]="$2"
}

add-zsh-hook preexec -record-command

# update vcs_info (slow) after any command that probably changed it.
function -maybe-show-vcs-info() {
	local LAST="$__HTABLE[LAST_COMMAND]"

	# in case user just hit enter, overwrite LAST_COMMAND, because preexec
	# won't run and it will otherwise linger.
	__HTABLE[LAST_COMMAND]="<unset>"

	# check first word; via:
	# http://tim.vanwerkhoven.org/post/2012/10/28/ZSH/Bash-string-manipulation
	case "$LAST[(w)1]" in
		cd|cp|git|rm|touch|mv)
			vcs_info
			;;
		*)
			;;
	esac
}

add-zsh-hook precmd -maybe-show-vcs-info	

###############################################################
# Dotfiles
###############################################################
# define alias to manage dotfiles repository
alias dot='/usr/bin/git --git-dir=$HOME/Git/dotfiles/.git --work-tree=$CONFIG_HOME'

###############################################################
# _Custom
###############################################################
# check for machine-specific rc file and source it if available
if [[ -s "${ZSH_CONFIG_HOME}/private.zsh" ]]; then
	source "${ZSH_CONFIG_HOME}/private.zsh"
fi