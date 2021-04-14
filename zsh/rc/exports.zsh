# define XDG_CACHE_HOME
export XDG_CACHE_HOME="$HOME/.cache"

# define XDG_CONFIG_HOME
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# define XDG_DATA_HOME
export XDG_DATA_HOME="$HOME/.local/share"

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

# enable syntax highlighting for less
export LESS="-iFMRX -x4"
export LESSCOLOR=always
export LESSCOLORIZER=/usr/bin/src-hilite-lesspipe.sh

# set location for less history file
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

# define the default pager
export PAGER=less

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
  export FZF_DEFAULT_COMMAND='fd -H --follow --type f --color=always -E .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  # define default options for fzf
  if hash bat 2> /dev/null; then
    __fzf_preview_opts="--ansi --preview-window 'right:60%' "
    export FZF_DEFAULT_OPTS=$__fzf_preview_opts
    unset __fzf_preview_opts
  fi

  export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=dark
    --color=fg:#bebebe,bg:-1,hl:#93b379
    --color=fg+:#dfe3ec,bg+:-1,hl+:#93b379
    --color=info:#4c566a,prompt:#6f8fb4,pointer:#b04b57
    --color=marker:#e5c179,spinner:#4c566a,header:#5f5f5f'
fi

# set location for vim runtime configuration
export MYVIMRC="${VIM_CONFIG_HOME}/vimrc"
__viminit=":set runtimepath+=${VIM_CONFIG_HOME},"
__viminit+="${VIM_CONFIG_HOME}/after"
if is_darwin; then
  # add fzf binary to rtp
  __viminit+=",/usr/local/opt/fzf"
fi
__viminit+="|:source ${MYVIMRC}"
__viminit+="|call functions#init()"
export VIMINIT=$__viminit
unset __viminit

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
export TERMINFO="$XDG_DATA_HOME/TERMINFO"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

# define configuration path for node.js
if hash node 2> /dev/null; then
  export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
fi

# define configuration path for npm
if hash npm 2> /dev/null; then
  export NPM_CONFIG_USERCONFIG="${CONFIG_HOME}/npm/npmrc"
  _cache="${XDG_CACHE_HOME}/npm"
  _initmod="${XDG_CACHE_HOME}/npm"
  _prefix="${XDG_CACHE_HOME}/npm"
  _tmp="${XDG_CACHE_HOME}/npm"
  cache=$(npm config get cache)
  initmod=$(npm config get init-module)
  prefix=$(npm config get prefix)
  tmp=$(npm config get tmp)
  if [[ "$_cache" != "$cache" ]]; then
    npm config set cache "$_cache"
  fi
  if [[ "$_initmod" != "$initmod" ]]; then
    npm config set init-module "$_initmod"
  fi
  if [[ "$EUID" -gt 0 ]]; then
    if [[ "$_prefix" != "$prefix " ]]; then
      npm config set prefix "$_prefix"
    fi
  fi
  if [[ "$_tmp" != "$tmp" ]]; then
    npm config set tmp "$_tmp"
  fi
  unset _cache
  unset _initmod
  unset _prefix
  unset _tmp
  unset cache
  unset initmod
  unset prefix
  unset tmp
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

# define configuration path for rustup
if hash rustup 2> /dev/null; then
  export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
fi

# define configuration path for wget
export WGETRC="$CONFIG_HOME/wget/wgetrc"
if [ ! -d "${CONFIG_HOME}/wget/" ]; then
  mkdir -p "${CONFIG_HOME}"/wget
fi
if [ ! -s "${CONFIG_HOME}/wget/wgetrc" ]; then
  echo hsts-file \= "$XDG_CACHE_HOME"/wget-hsts >> "$XDG_CONFIG_HOME/wget/wgetrc"
fi
