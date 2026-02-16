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

# define location of claude code configuration
export CLAUDE_CONFIG_DIR="${CONFIG_HOME}/claude"

# announce true color support (this is incorrect but required)
export COLORTERM=truecolor

# suppress spell check on dotfiles
export CORRECT_IGNORE_FILE='.*'

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
export KEYTIMEOUT=5

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

# define location of zettelkasten vault
export ZK_NOTEBOOK_DIR="${HOME}/Documents/_notes/zettelkasten/vault"

# define location of eza config
if hash eza 2> /dev/null; then
  export EZA_CONFIG_DIR="${CONFIG_HOME}/eza"
fi

# (no direct export) load angular completions when available
if hash ng 2> /dev/null; then
  _evalcache ng completion script
fi

# set the default editor
if hash nvim 2> /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

if hash fzf 2> /dev/null; then
  # setup fzf key bindings and fuzzy completion (>=v0.48.0)
  FZF_ALT_C_COMMAND="" _evalcache fzf --zsh

  # Use ? as the trigger sequence instead of the default **
  export FZF_COMPLETION_TRIGGER='?'

  # set fd as the default source for fzf
  export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f --color=always -E .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

  fzf_catppuccin_frappe=" \
    --color=bg+:#414559 \
    --color=bg:#303446 \
    --color=border:#737994 \
    --color=fg+:#c6d0f5 \
    --color=fg:#c6d0f5 \
    --color=header:#e78284
    --color=hl+:#e78284 \
    --color=hl:#e78284 \
    --color=info:#ca9ee6 \
    --color=label:#c6d0f5 \
    --color=marker:#babbf1 \
    --color=pointer:#f2d5cf \
    --color=prompt:#ca9ee6 \
    --color=selected-bg:#51576d \
    --color=spinner:#f2d5cf"

  fzf_catppuccin_macchiato=" \
      --color=bg+:#363a4f \
      --color=bg:#24273a \
      --color=border:#6e738d \
      --color=fg+:#cad3f5 \
      --color=fg:#cad3f5 \
      --color=header:#ed8796 \
      --color=hl+:#ed8796 \
      --color=hl:#ed8796 \
      --color=info:#c6a0f6 \
      --color=label:#cad3f5 \
      --color=marker:#b7bdf8 \
      --color=pointer:#f4dbd6 \
      --color=prompt:#c6a0f6 \
      --color=selected-bg:#494d64 \
      --color=spinner:#f4dbd6"

  fzf_catppuccin_mocha=" \
    --color=bg+:#313244 \
    --color=bg:#1e1e2e \
    --color=border:#6c7086 \
    --color=fg+:#cdd6f4 \
    --color=fg:#cdd6f4 \
    --color=header:#f38ba8 \
    --color=hl+:#f38ba8 \
    --color=hl:#f38ba8 \
    --color=info:#cba6f7 \
    --color=label:#cdd6f4 \
    --color=marker:#b4befe \
    --color=pointer:#f5e0dc \
    --color=prompt:#cba6f7 \
    --color=selected-bg:#45475a \
    --color=spinner:#f5e0dc"

  fzf_kdark=" \
    --color=bg+:#303031 \
    --color=bg:#303031 \
    --color=border:#303031 \
    --color=fg+:#d8dee9 \
    --color=fg:#b8bec9 \
    --color=gutter:#303031 \
    --color=header:#6f8fb4 \
    --color=hl+:#97b182 \
    --color=hl:#7f966d \
    --color=info:#59595e \
    --color=marker:#bf616a
    --color=pointer:#b8bec9 \
    --color=preview-bg:#1f2021 \
    --color=preview-border:#59595e \
    --color=preview-scrollbar:#3a3c3d \
    --color=prompt:#7f966d \
    --color=scrollbar:#373737 \
    --color=spinner:#5f8f9d"

  fzf_tokyonight=" \
    --color=bg+:#283457 \
    --color=bg:#16161e \
    --color=border:#27a1b9 \
    --color=fg:#c0caf5 \
    --color=gutter:#16161e \
    --color=header:#ff9e64 \
    --color=hl+:#2ac3de \
    --color=hl:#2ac3de \
    --color=info:#545c7e \
    --color=marker:#ff007c \
    --color=pointer:#ff007c \
    --color=prompt:#2ac3de \
    --color=query:#c0caf5:regular \
    --color=scrollbar:#27a1b9 \
    --color=separator:#ff9e64 \
    --color=spinner:#ff007c"

  fzf_tokyonight_storm=" \
    --color=bg+:#2e3c64 \
    --color=bg:#1f2335 \
    --color=border:#29a4bd \
    --color=fg:#c0caf5 \
    --color=gutter:#1f2335 \
    --color=header:#ff9e64 \
    --color=hl+:#2ac3de \
    --color=hl:#2ac3de \
    --color=info:#545c7e \
    --color=marker:#ff007c \
    --color=pointer:#ff007c \
    --color=prompt:#2ac3de \
    --color=query:#c0caf5:regular \
    --color=scrollbar:#29a4bd \
    --color=separator:#ff9e64 \
    --color=spinner:#ff007c"

  # define default options for fzf
  export FZF_DEFAULT_OPTS=" \
    --ansi \
    --border \
    --cycle \
    --header-first \
    --height=50% \
    --margin=1,2,1,2 \
    --layout=reverse \
    --preview-window=border-thinblock \
    --scroll-off=3 \
    --bind=ctrl-d:preview-down \
    --bind=ctrl-f:preview-up \
    --bind=tab:toggle-out \
    --bind=shift-tab:toggle-in \
    --prompt=\" \" \
    --pointer=\"\" \
    --marker=\"\" \
    --scrollbar=\"▌▐\" \
    --color=dark \
    ${fzf_kdark}"

  unset fzf_kdark
  unset fzf_tokyonight fzf_tokyonight_storm
  unset fzf_catppuccin_frappe fzf_catppuccin_macchiato fzf_catppuccin_mocha

  # define default behaviour for ctrl-t
  export FZF_CTRL_T_OPTS="
  --select-1
  --exit-0
  --preview '(bat --style=numbers {} || cat {} || tree -C {}) 2> /dev/null | head -200'"

  # define default behaviour for fzf-tmux
  export FZF_TMUX_OPTS="-p 90%"

  # load fzf extras
  test -s "${ZSH_CONFIG_HOME}/plugins/fzf.zsh" \
    && source "${ZSH_CONFIG_HOME}/plugins/fzf.zsh"
fi

# define mocOS specific options
if is_darwin; then
  # ensure utf-8 is set
  export LC_CTYPE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

  # ensure brew overrides are defined
  export BREW_PREFIX="${BREW_PREFIX:-/opt/homebrew}"
  export MANPATH="$BREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}"

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
if test -d "$XDG_DATA_HOME/cargo" || hash cargo 2> /dev/null; then
  export CARGO_HOME="$XDG_DATA_HOME/cargo"
  export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
fi

# define configuration path for dotnet
if hash dotnet 2> /dev/null; then
  _dotnet_env() {
    echo "export DOTNET_CLI_HOME=\"${CONFIG_HOME}/dotnet\""
    echo "export DOTNET_CLI_TELEMETRY_OPTOUT=1"
    [ -d /usr/local/share/dotnet ] && {
      echo "export DOTNET_ROOT=\"/usr/local/share/dotnet\""
      return
    }
    is_gentoo || return
    local _dotnet_root
    _dotnet_root=$(
      eselect dotnet list 2>/dev/null \
        | grep "$(eselect dotnet show)" 2>/dev/null \
        | grep -oP '\(\K[^\)]+'
    )
    [ -d "$_dotnet_root" ] && echo "export DOTNET_ROOT=\"$_dotnet_root\""
  }
  _evalcache _dotnet_env
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

# define configuration path for luarocks
if hash luarocks 2> /dev/null; then
  _luarocks_env() {
    echo "export LUA_PATH=\"$(luarocks path --lr-path)\""
    if is_gentoo; then
      echo "export LUA_PATH=\"/usr/share/lua/5.1/?.lua;$LUA_PATH\""
    fi
    echo "export LUA_CPATH=\"$(luarocks path --lr-cpath)\""
  }
  _evalcache _luarocks_env
fi

# define configuration path for mysql
if hash mysql 2> /dev/null; then
  export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
fi

# define configuration path for ncurses on linux
if ! is_darwin; then
  export TERMINFO="$XDG_DATA_HOME/terminfo"
  export TERMINFO_DIRS="$TERMINFO_DIRS:$XDG_DATA_HOME/terminfo"
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

  _npm_env() {
    local _cache="${XDG_CACHE_HOME}/npm"
    local _initmod="${XDG_CACHE_HOME}/npm"
    local _notifier="false"
    local _prefix="${XDG_DATA_HOME}/npm"
    local _current=$(npm config get prefix)
    npm config set cache "$_cache"
    npm config set init-module "$_initmod"
    npm config set update-notifier "$_notifier"
    if [[ "$EUID" -gt 0 ]] && [[ "$_current" != "$prefix" ]]; then
      npm config set prefix "$_prefix"
    fi
    echo "NPM_CONFIG_USERPREFIX=$_prefix"
  }
  _evalcache _npm_env
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

# define configuration path for terraform
if hash terraform 2> /dev/null; then
  export TF_CLI_CONFIG_FILE="${CONFIG_HOME}/terraform/terraformrc"
  export TF_PLUGIN_CACHE_DIR="${XDG_CACHE_HOME}/terraform/plugins"
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

# load zoxide util when available
if hash zoxide 2> /dev/null; then
  export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
  export _ZO_EXCLUDE_DIRS="$HOME:$HOME/Downloads/*:*/.git:/tmp/*"
  export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS"
  # WARN: creating an alias for `cd` breaks vcs_info
  # _evalcache zoxide init --cmd cd zsh
  _evalcache zoxide init zsh
fi

# load uv configuration when available
if hash uv 2> /dev/null; then
  export UV_CACHE_DIR="${XDG_CACHE_HOME}/uv"
  if [ ! -d "${UV_CACHE_DIR}" ]; then
    mkdir -p "${UV_CACHE_DIR}"
  fi

  _uv_complete() {
    unfunction _uv_complete 2>/dev/null
    hash uv 2>/dev/null || return
    _evalcache uv generate-shell-completion zsh
    _evalcache uvx --generate-shell-completion zsh
  }
  compdef _uv_complete uv
  compdef _uv_complete uvx
fi
