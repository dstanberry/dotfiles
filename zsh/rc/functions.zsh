# shellcheck disable=SC2148

# poor man's ag runtime configuration
function ag() {
  emulate -L zsh
  command ag --pager="less -iFMRSX -x4" \
    --color-path=34\;3 \
    --color-line-number=33 \
    --color-match=35\;1\;4 "$@"
  }

# support custom sub-commands
function cargo() {
  local PKG=$CONFIG_HOME/shared/packages/cargo.txt
  if [ "$1" = "save" ]; then
    command cargo install --list | grep -E '^\w+' | awk '{ print $1 }' > "$PKG"
  elif [ "$1" = "load" ]; then
    < "$PKG" xargs "cargo" install
  else
    command cargo "$@"
  fi
}

# interactively delete file(s) by name
function del() {
  emulate -L zsh
  if [ $# -eq 0 ]; then
    echo "error: at least one argument is required"
    return 1
  fi
  local filename=$1
  if [[ $filename == .* ]]; then
    filename=${filename/#/\\}
  fi
  if [ $# -eq 2 ]; then
    fd "^${filename}$" $2 -tf -X rm -i
  else
    fd "^${filename}$" -tf -X rm -i
  fi
}

# poor man's fd runtime configuration
function fd() {
  emulate -L zsh
  command fd -H "$@"
}

# find in history
function fh() {
  print -z "$( ([ -n "$ZSH_NAME" ] && fc -l 1) || history \
    | fzf +s --tac \
    | sed -r 's/ *[0-9]*\*? *//' \
    | sed -r 's/\\/\\\\/g')"
  }

# fix corrupt history file
function fix_hist() {
  mv "${XDG_CACHE_HOME}"/zsh/history "${XDG_CACHE_HOME}"/zsh/hist_corrupt
  strings "${XDG_CACHE_HOME}"/zsh/hist_corrupt > "${XDG_CACHE_HOME}"/zsh/history
  fc -R "${XDG_CACHE_HOME}"/zsh/history
  rm "${XDG_CACHE_HOME}"/zsh/hist_corrupt
}

# find process by name and highlight
function fp() {
  ps aux | grep -v grep | grep -i "$@"
}

# support custom sub-commands
function gem() {
  local PKG=$CONFIG_HOME/shared/packages/gem.txt
  if [ "$1" = "load" ]; then
    < "$PKG" xargs "gem" install
  else
    command gem "$@"
  fi
}

# support custom sub-commands
function go() {
  local PKG=$CONFIG_HOME/shared/packages/go.txt
  if [ "$1" = "load" ]; then
    < "$PKG" xargs "go" install
  else
    command go "$@"
  fi
}

# print response headers, following redirects.
function headers() {
  if [ $# -ne 1 ]; then
    echo "error: a host argument is required"
    return 1
  fi
  local REMOTE=$1
  curl -sSL -D - "$REMOTE" -o /dev/null
}

# support custom sub-commands
function luarocks() {
  local PKG=$CONFIG_HOME/shared/packages/luarocks.txt
  if [ "$1" = "load" ]; then
    < "$PKG" xargs "luarocks" --tree="${XDG_DATA_HOME}/luarocks" install
  else
    command luarocks "$@"
  fi
}

# simple notes manager
function notes() {
  local MODE_EDIT="edit"
  local MODE_REMOVE="remove"
  local MODE_LIST="list"
  local MODE_HELP="help"
  local MODE_DEFAULT="$MODE_LIST"
  local mode="$MODE_EDIT"
  local -a COMMAND_REMOVE
  COMMAND_REMOVE=(delete remove del rm d r)
  local -a COMMAND_LIST
  COMMAND_LIST=(list ls l)
  local -a COMMAND_EDIT
  COMMAND_EDIT=(edit e)
  local -a COMMAND_HELP
  COMMAND_HELP=(help h)
  local date="$(date +'%Y-%m-%d')"
  local human_date="$(date +'%A, %B %d, %Y (%Y-%m-%d)')"
  if [[ -d "$HOME/Documents/_notes" ]]; then
    local base_path="$HOME/Documents/_notes"
  else
    local base_path="${XDG_DATA_HOME:-$HOME/.local/share}/notes"
    mkdir -p "$base_path"
  fi
  local DEFAULT_NOTE_FILE="default"
  local DEFAULT_NOTE_NAME="default"
  local DEFAULT_NOTE_TITLE="General Notes"
  local note_file=""
  local note_title=""
  local note_name=""
  local note_path=""
  local cmd="$1"
  if [[ ${COMMAND_REMOVE[(ie)$cmd]} -le ${#COMMAND_REMOVE} ]]; then
    mode="$MODE_REMOVE"
    shift
    cmd="$1"
  elif [[ ${COMMAND_EDIT[(ie)$cmd]} -le ${#COMMAND_EDIT} ]]; then
    mode="$MODE_EDIT"
    shift
    cmd="$1"
  elif [[ ${COMMAND_LIST[(ie)$cmd]} -le ${#COMMAND_LIST} ]]; then
    mode="$MODE_LIST"
    shift
    cmd="$1"
  elif [[ ${COMMAND_HELP[(ie)$cmd]} -le ${#COMMAND_HELP} ]]; then
    mode="$MODE_HELP"
    shift
    cmd="$1"
  elif [ "$cmd" = "" ]; then
    mode="$MODE_DEFAULT"
  fi
  if [ "$cmd" = "date" ]; then
    note_name="date"
    note_title="Notes for $human_date"
    note_file="$date.md"
  elif [ "$cmd" = "" ]; then
    note_name="$DEFAULT_NOTE_NAME"
    note_title="$DEFAULT_NOTE_TITLE"
    note_file="$DEFAULT_NOTE_FILE.md"
  else
    note_name="$cmd"
    note_title="Notes for $cmd"
    note_file="$cmd.md"
  fi
  note_path="$base_path/$note_file"
  if [ "$mode" = "$MODE_EDIT" ] && [ ! -f "$note_path" ]; then
    builtin echo "# $note_title" >> "$note_path"
    builtin echo "" >> "$note_path"
  fi
  if [ "$mode" = "$MODE_EDIT" ]; then
    $EDITOR "$note_path"
  elif [ "$mode" = "$MODE_REMOVE" ]; then
    if [ ! -f "$note_path" ]; then
      builtin echo "No note exists for $note_name!"
    else
      rm -i "$note_path"
    fi
  elif [ "$mode" = "$MODE_LIST" ]; then
    ls "$base_path"
  elif [ "$mode" = "$MODE_HELP" ]; then
    builtin echo "Usage: notes [<command>] [<name>]
Commands
= $MODE_EDIT =
  Aliases: $COMMAND_EDIT
  Arguments:
    - name: Name of the note to edit without the .md extension
= $MODE_REMOVE =
  Aliases: $COMMAND_REMOVE
  Arguments:
    - name: Name of the note to remove without the .md extension
= $MODE_LIST =
  Aliases: $COMMAND_LIST
  Arguments:
= $MODE_HELP =
  Aliases $COMMAND_HELP
  Arguments:
By default, if no command is provided and no name is provided, all notes will \
be listed.
By default, if no command is provided and a name is provided, the note with the \
provided name will be opened (or created if does not exist) for editing."
  fi
}

# support custom sub-commands
function npm() {
  local PKG=$CONFIG_HOME/shared/packages/npm.txt
  if [ "$1" = "save" ]; then
    if [ "$EUID" -eq 0 ]; then
    npm list -g --depth=0 | awk '{ print $2 }' \
      | sed -r 's/^\(empty\)//' \
      | sed '/^$/d' | grep -v 'npm@' > "$PKG"
    else
    sudo npm list -g --depth=0 | awk '{ print $2 }' \
      | sed -r 's/^\(empty\)//' \
      | sed '/^$/d' | grep -v 'npm@' > "$PKG"
    fi
  elif [ "$1" = "load" ]; then
    if [ "$EUID" -eq 0 ]; then
      < "$PKG" xargs "npm" install -g
    else
      < "$PKG" xargs sudo "npm" install -g
    fi
  else
    command npm "$@"
  fi
}

# support custom sub-commands
function pip() {
  local PKG=$CONFIG_HOME/shared/packages/pip.txt
  if [ "$1" = "save" ]; then
    if hash pipdeptree 2>/dev/null; then
      if [ is_gentoo ]; then
        command pipdeptree --user --warn silence | grep -E '^\w+' > "$PKG"
      else
        command pipdeptree --warn silence | grep -E '^\w+' > "$PKG"
      fi
    else
      echo "unable to find pipdeptree. try running 'pip install pipdeptree'"
      return 1
    fi
  elif [ "$1" = "load" ]; then
    if [ is_gentoo ]; then
      command pip install --user --requirement "$PKG" --upgrade
    else
      command pip install --requirement "$PKG" --upgrade
    fi
  else
    command pip "$@"
  fi
}

# poor man's rg runtime configuration
function rg() {
  command rg --colors line:fg:yellow \
    --colors line:style:bold \
    --colors path:fg:blue \
    --colors path:style:bold \
    --colors match:fg:magenta \
    --colors match:style:underline \
    --smart-case \
    --pretty "$@" | less -iFMRSX
  }

# display information about a remote ssl certificate
function ssl() {
  emulate -L zsh
  if [ $# -eq 0 ]; then
    echo "error: a host argument is required"
    return 1
  fi
  local REMOTE=$1
  if [ $# -eq 2 ];then
    local PORT=$2
    echo | openssl s_client -showcerts -servername "$REMOTE" \
      -connect "$REMOTE:$PORT" 2>/dev/null \
      | openssl x509 -inform pem -noout -text
        else
          echo | openssl s_client -showcerts -servername "$REMOTE" \
            -connect "$REMOTE:443" 2>/dev/null \
            | openssl x509 -inform pem -noout -text
  fi
}

# print a pruned version of a tree
function subtree() {
  tree -a --prune -P "$@"
}

# try to run tmux with session management
function tmux() {
  emulate -L zsh
  local SOCK_SYMLINK=~/.ssh/ssh_auth_sock
  if [ -r "$SSH_AUTH_SOCK" ] && [ ! -L "$SSH_AUTH_SOCK" ]; then
    ln -sf "$SSH_AUTH_SOCK" $SOCK_SYMLINK
  fi
  if [[ -n "$*" ]]; then
    env SSH_AUTH_SOCK=$SOCK_SYMLINK tmux "$@"
    return
  fi
  if [ -x .tmux ]; then
    local DIGEST
	DIGEST="$(openssl dgst -sha512 .tmux)"
    if ! grep -q "$DIGEST" "${TMUX_CONFIG_HOME}"/tmux.digests 2> /dev/null; then
      cat .tmux
      read -k 1 -r \
        'REPLY?Trust (and run) this .tmux file? (t = trust, otherwise = skip) '
              echo
              if [[ $REPLY =~ ^[Tt]$ ]]; then
                echo "$DIGEST" >> "${TMUX_CONFIG_HOME}"/tmux.digests
                ./.tmux
                return
              fi
            else
              ./.tmux
              return
    fi
  fi
  local SESSION_NAME
  SESSION_NAME=$(basename ${$(pwd)//[.:]/_})
  env SSH_AUTH_SOCK=$SOCK_SYMLINK tmux new -A -s "$SESSION_NAME"
}

# traverse parent directories in a trivial manner
function up() {
  if [[ "$#" == 0 ]]; then
    cd ..
  else
    for ((i=0; i<$1; i++)) ; do
      CDSTR="../$CDSTR"
    done
    cd "$CDSTR" || exit
  fi
}

# define configuration path for vim
function vim() {
  local MYVIMRC="${VIM_CONFIG_HOME}/vimrc"
  local __viminit=":set runtimepath+=${VIM_CONFIG_HOME},"
  __viminit+="${VIM_CONFIG_HOME}/after"
  if is_darwin; then
    # add fzf binary to rtp
    __viminit+=",/usr/local/opt/fzf"
  fi
  __viminit+="|:source ${MYVIMRC}"
  local viminit="VIMINIT='$__viminit'"
  eval "$viminit command vim $*"
}

# poor man's wget runtime configuration
function wget() {
  command wget --hsts-file "${XDG_CACHE_HOME}/wget/wget-hsts" "$@"
}

# poor man's yarn runtime configuration
function yarn() {
  command yarn --use-yarnrc "${CONFIG_HOME}/yarn/config" "$@"
}
