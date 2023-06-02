# shellcheck disable=SC2148

# define XDG_CACHE_HOME
export XDG_CACHE_HOME="$HOME/.cache"

# define XDG_CONFIG_HOME
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# define XDG_DATA_HOME
export XDG_DATA_HOME="$HOME/.local/share"

# define XDG_STATE_HOME
export XDG_STATE_HOME="$HOME/.local/state"

# define UID
if hash id 2> /dev/null; then
  __uid="$(id -u)"
  export UID="$__uid"
  unset __uid
else
  export UID=$UID
fi

# define XDG_RUNTIME_DIR
export XDG_RUNTIME_DIR="/tmp/${UID}-runtime-dir"
if ! test -d "${XDG_RUNTIME_DIR}"; then
  mkdir "${XDG_RUNTIME_DIR}"
  chmod 0700 "${XDG_RUNTIME_DIR}"
fi

# announce true color support (this is incorrect but required)
export COLORTERM=truecolor

# define default name of primary upstream git branch
export GIT_REVIEW_BASE=main

# enable terminal colors in output
export GH_FORCE_TTY="100%"

# use standard ISO 8601 timestamp
export HISTTIMEFORMAT='%F %T '

# don't put duplicate lines in the history.
export HISTCONTROL=erasedups:ignoreboth

# ignore commands that have no forensic value
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# define history file location
export HISTFILE="${XDG_CACHE_HOME}/zsh/history"

# save the history
export SAVEHIST=$HISTSIZE

# define how long to wait for additional characters
export KEYTIMEOUT=2

# enable syntax highlighting for less
export LESS="-iFMRX -x4"
export LESSCOLOR=always
export LESSCOLORIZER=/usr/bin/src-hilite-lesspipe.sh

# set location for less history file
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

# define the default pager
export PAGER=less

# define location for local projects
export PROJECTS_DIR="${HOME}/Projects"

# define the default manpager
export MANPAGER='nvim +Man!'

# set the default editor
if hash nvim 2> /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

if hash fzf 2> /dev/null; then
  # Use ? as the trigger sequence instead of the default **
  export FZF_COMPLETION_TRIGGER='?'

  # set fd as the default source for fzf
  export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f --color=always -E .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # define default options for fzf
  export FZF_DEFAULT_OPTS='
    --ansi
    --border
    --cycle
    --header-first
    --height=40%
    --layout=reverse
    --preview-window border-left
    --scroll-off=3
    --bind=ctrl-d:preview-down
    --bind=ctrl-f:preview-up
    --bind=tab:toggle-out
    --bind=shift-tab:toggle-in
    --prompt=" "
    --pointer=""
    --marker=""
    --scrollbar="▌▐"
    --color=dark
    --color=fg:#bebebe,bg:#303033,hl:#93b379
    --color=fg+:#dfe3ec,bg+:#303033,hl+:#93b379
    --color=gutter:#303033,border:#303033,scrollbar:#373737
    --color=preview-bg:#1f2021,preview-border:#1f2021,preview-scrollbar:#000000
    --color=info:#5f5f5f,prompt:#93b379,pointer:#bebebe
    --color=marker:#b04b57,spinner:#516882,header:#97b6e5'

    # define default behaviour for ctrl-t
  export FZF_CTRL_T_OPTS="
  --select-1
  --exit-0
  --preview '(bat --style=plain {} || cat {} || tree -C {}) 2> /dev/null | head -200'"
fi

# define mocOS specific options
if is_darwin; then
  # ensure utf-8 is set
  export LC_CTYPE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

  # ensure brew apps are not quarantined
  export HOMEBREW_CASK_OPTS=--no-quarantine
fi

# define configuration path for ack
if hash ack 2> /dev/null; then
  export ACKRC="${CONFIG_HOME}/ack/ackrc"
fi

# define configuration path for bat
if hash bat 2> /dev/null; then
  export BAT_CONFIG_PATH="${CONFIG_HOME}/bat/bat.conf"
fi

# define configuration path for rust-cargo
if hash cargo 2> /dev/null; then
  export CARGO_HOME="$XDG_DATA_HOME/cargo"
  export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
fi

# define configuration path for rubygems
if hash gem 2> /dev/null; then
  export GEMRC="${CONFIG_HOME}/gem/gemrc"
  export GEM_HOME="${XDG_DATA_HOME}/gem"
  export GEM_SPEC_CACHE="${XDG_CACHE_HOME}/gem"
fi

# define configuration path for go
if hash go 2> /dev/null; then
  export GOPATH="$XDG_DATA_HOME/go"
fi

# define configuration path for gpg
if hash gpg 2> /dev/null; then
  export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
fi

# define configuration path for mysql
if hash mysql 2> /dev/null; then
  export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
fi

# define configuration path for ncurses
if ! is_darwin; then
  export TERMINFO="$XDG_DATA_HOME/TERMINFO"
  export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
fi

# define configuration path for tree-sitter
export TREE_SITTER_DIR="$XDG_DATA_HOME/tree-sitter"

# define configuration path for node.js
if hash node 2> /dev/null; then
  export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
fi

# define configuration path for npm
if hash npm 2> /dev/null; then
  export NPM_CONFIG_USERCONFIG="${CONFIG_HOME}/npm/npmrc"
fi

# define configuration path for postgresql
if hash psql 2> /dev/null; then
  export PSQLRC="$CONFIG_HOME/pg/psqlrc"
  export PSQL_HISTORY="$XDG_CACHE_HOME/pg/psql_history"
  export PGPASSFILE="$CONFIG_HOME/pg/pgpass"
  export PGSERVICEFILE="$CONFIG_HOME/pg/pg_service.conf"
  if [ ! -d "$CONFIG_HOME/pg" ]; then
    mkdir "$CONFIG_HOME/pg"
  fi
  if [ ! -d "$XDG_CACHE_HOME/pg" ]; then
    mkdir "$XDG_CACHE_HOME/pg"
  fi
fi

# prevent virtualenv from automatically modifying prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# define configuration path for wget
export WGETRC="$CONFIG_HOME/wget/wgetrc"
if [ ! -d "${CONFIG_HOME}/wget/" ]; then
  mkdir -p "${CONFIG_HOME}"/wget
fi
if [ ! -s "${CONFIG_HOME}/wget/wgetrc" ]; then
  echo hsts-file \= "$XDG_CACHE_HOME"/wget-hsts >> "$XDG_CONFIG_HOME/wget/wgetrc"
fi
