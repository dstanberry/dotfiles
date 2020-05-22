###############################################################
## Helper Function to Deduplicateariables
###############################################################
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

###############################################################
# Environment Variables
###############################################################
# support user binaries
LOCAL="${HOME}/.local/bin"

test -s "${LOCAL}" && \
export PATH=$PATH:$LOCAL

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

###############################################################
# Completions
###############################################################
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

# track the number of commands local to this shell
HISTCMD_LOCAL=0

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

# Use "cbt" capability ("back_tab", as per `man terminfo`), if we have it:
if tput cbt &> /dev/null; then
	bindkey "$(tput cbt)" reverse-menu-complete # make Shift-tab go to previous completion
fi

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

autoload -U edit-command-line
zle -N edit-command-line
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
zle -N fg-bg
bindkey '^Z' fg-bg

###############################################################
# Color
###############################################################
# enable true color support
export TERM=xterm-256color

# # enable syntax highlighting for less
export LESS="-iFMRX"
export LESSCOLOR=always
export LESSCOLORIZER=/usr/bin/src-hilite-lesspipe.sh

# # set location for less history file
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

# setup shell prompt
test -s "${ZSH_CONFIG_HOME}/prompt.zsh" && \
source "${ZSH_CONFIG_HOME}/prompt.zsh"
#
# define alias to reload zsh configuration
alias reload='source "${ZSH_CONFIG_HOME}/.zshrc"'

autoload -U select-word-style
select-word-style bash

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
