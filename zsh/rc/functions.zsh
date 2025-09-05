# support custom sub-commands
cargo() {
  local PKG=$CONFIG_HOME/shared/packages/cargo.txt
  is_darwin && PKG=$CONFIG_HOME/shared/packages/cargo-macos.txt
  case "$1" in
    load)
      [ "$EUID" -eq 0 ] && {
        echo "cargo load is not supported for root user"
        exit 1
      }
      while IFS= read -r line; do
        [ -n "$line" ] && cargo install ${(z)line}
      done <"$PKG"
      return ;;
    save)
      command cargo install --list | grep -E '^\w+' | awk '{print $1}' >"$PKG"
      return ;;
  esac
  command cargo "$@"
}

# manually remove duplicate entries in history
clean_hist() {
  local tempfile=$(mktemp)
  command cat -n "${XDG_CACHE_HOME}/zsh/history" \
    | sort -t ';' -uk2 \
    | sort -nk1 \
    | cut -f2- > $tempfile
  mv $tempfile "${XDG_CACHE_HOME}/zsh/history"
}

# interactively delete file(s) by name
del() {
  emulate -L zsh
  [ $# -gt 0 ] || { echo "error: at least one argument is required"; return 1; }
  local filename=$1
  [[ $filename == .* ]] && filename=${filename/#/\\}
  [ $# -eq 2 ] && { fd "^${filename}$" "$2" -tf -X rm -i; return; }
  fd "^${filename}$" -tf -X rm -i
}

# use side-by-side diff view if shell width is large enough
delta() {
  [[ -n "$COLUMNS" && "$COLUMNS" -gt 200 ]] \
    && command delta --side-by-side --width "$COLUMNS" "$@" \
    || command delta "$@"
}

# poor man's fd runtime configuration
fd() {
  emulate -L zsh
  command fd -H "$@"
}

# fuzzy search for files in the current directory and open in (n)vim
fe() {
  IFS=$'\n' files=($(fzf \
    --tmux=90%\
    --query="$1" \
    --multi \
    --select-1 \
    --exit-0 \
    --preview '(bat --style=numbers {} || cat {} || tree -C {}) | head -200'))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fix corrupt history file
fix_hist() {
  mv "${XDG_CACHE_HOME}"/zsh/history "${XDG_CACHE_HOME}"/zsh/hist_corrupt
  strings "${XDG_CACHE_HOME}"/zsh/hist_corrupt > "${XDG_CACHE_HOME}"/zsh/history
  fc -R "${XDG_CACHE_HOME}"/zsh/history
  rm "${XDG_CACHE_HOME}"/zsh/hist_corrupt
}

# find process by name and highlight
fp() {
  ps aux | grep -v grep | grep -i "$@"
}

# support custom sub-commands
gem() {
  local PKG=$CONFIG_HOME/shared/packages/gem.txt
  case "$1" in
    load)
      [ "$EUID" -eq 0 ] && {
        echo "gem load is not supported for root user"
        exit 1
      }
      while IFS= read -r line; do
        [ -n "$line" ] && gem install ${(z)line}
      done <"$PKG"
      return ;;
  esac
  command gem "$@"
}

# support custom sub-commands
git() {
  emulate -L zsh
  case "$1" in
    wta)
      local branches=("${(@f)$(git branch | cut -c 3-)}")
      local root=$(command git rev-parse --path-format=absolute \
        --git-common-dir)
      local dir_name="${2//\//-}"
      local wt_path="$root/$dir_name"
      (( $branches[(Ie)$2] )) \
        && command git worktree add "$wt_path" "$2" \
        || command git worktree add -b "$2" "$wt_path"
      [ -d "$wt_path" ] && cd "$wt_path"; return ;;
    wtl)
      local wt_path
      wt_path=$(git worktree list | fzf --exit-0 --no-multi \
        --header="Switch worktree" \
        --preview="git graph -50 --color=always" | awk '{print $1}')
      [ -d "$wt_path" ] && cd "$wt_path"; return ;;
    track-remote)
      command git config remote.origin.fetch \
        "+refs/heads/*:refs/remotes/origin/*"; return ;;
  esac
  command git "$@"
}

# support custom sub-commands
go() {
  local PKG=$CONFIG_HOME/shared/packages/go.txt
  is_darwin && PKG=$CONFIG_HOME/shared/packages/go-macos.txt
  case "$1" in
    load)
      [ "$EUID" -eq 0 ] && {
        echo "go load is not supported for root user"
        exit 1
      }
      while IFS= read -r line; do
        [ -n "$line" ] && go install ${(z)line}
      done <"$PKG"
      return ;;
  esac
  command go "$@"
}

# print response headers, following redirects.
headers() {
  [ $# -eq 1 ] || { echo "error: need a host"; return 1; }
  curl -sSL -D - "$1" -o /dev/null
}

# support custom sub-commands
luarocks() {
  local LUA_VERSION="5.1"
  local TREE="${XDG_DATA_HOME}/luarocks"
  local PKG="$CONFIG_HOME/shared/packages/luarocks.txt"
  case "$1" in
    load)
      local -a installed missing wanted
      installed=("${(@f)$(luarocks \
         --lua-version="$LUA_VERSION" \
         --tree="$TREE" \
         list --porcelain \
         | awk -F'\t' 'NF{print $1}' \
         | sort -u)}")
      local line name
      while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        name="${line%% *}"
        if (( ! $installed[(Ie)$name] )); then
          missing+="$line"
        fi
        wanted+="$line"
      done < "$PKG"
      if (( ${#missing} == 0 )); then
        echo "luarocks: all requested rocks already installed"
        return 0
      fi
      local rockspec
      mkdir -p "$TREE"
      rockspec="$TREE/zsh-rocks-user-rockspec-0.0-0.rockspec"
      {
        echo 'rockspec_format = "3.0"'
        echo 'package = "zsh-rocks-user-rockspec"'
        echo 'version = "0.0-0"'
        echo 'source = { url = "no-url" }'
        echo 'dependencies = {'
        for line in "${wanted[@]}"; do
          printf '  "%s",\n' "${line//"/\\"}"
        done
        echo '}'
        echo 'build = { type = "builtin" }'
      } > "$rockspec"
      echo "luarocks: installing missing (${#missing}) via single rockspec"
      command luarocks \
          --lua-version="$LUA_VERSION" \
          --tree="$TREE" \
          install \
          --server="https://nvim-neorocks.github.io/rocks-binaries/" \
          --deps-only \
          "$rockspec"
      rm -rf -- "$rockspec"
      ;;
    *)
      command luarocks "$@"
      ;;
  esac
}

# custom |zk| wrapper
notes() {
  emulate -L zsh
  [ $# -eq 0 ] && { zk list; return; }
  case "$1" in
    edit) zk edit --interactive; return ;;
    list) zk list; return ;;
    new)
      local dir title=""
      dir=(
        $( fd . "$ZK_NOTEBOOK_DIR" --type d --exclude '.zk' -X printf '%s\n' {/} |
          fzf --ansi --exit-0 --no-multi \
            --header 'Create note within:' \
            --bind 'focus:transform-header(echo Create note within {1})' \
            --preview '(eza -lh --icons $ZK_NOTEBOOK_DIR/{1} || ls -lh $ZK_NOTEBOOK_DIR/{1}) 2> /dev/null' )
      )
      [ -n "$dir" ] || return
      vared -p 'Note title: ' title
      zk new "${dir}" --title "$title"
      ;;
  esac
}

# support custom sub-commands
npm() {
  local PKG=$CONFIG_HOME/shared/packages/npm.txt
  case "$1" in
    load)
      [ "$EUID" -eq 0 ] && {
        echo "npm load is not supported for root user"
        exit 1
      }
      while IFS= read -r line; do
        [ -n "$line" ] && npm install -g ${(z)line}
      done <"$PKG"
      return ;;
    save)
      local cmd="sudo npm list -g --depth=0"
      [ "$EUID" -eq 0 ] && cmd="npm list -g --depth=0"
      $cmd | awk '{print $2}' \
        | sed -r 's/^\(empty\)//' \
        | sed '/^$/d' \
        | grep -v 'npm@' >"$PKG"
      return ;;
  esac
  command npm "$@"
}

# poor man's rg runtime configuration
rg() {
  command rg \
    --colors line:fg:yellow \
    --colors line:style:bold \
    --colors path:fg:blue \
    --colors path:style:bold \
    --colors match:fg:magenta \
    --colors match:style:underline \
    --smart-case \
    --pretty "$@" | less -iFMRSX
}

# display information about a remote ssl certificate
ssl() {
  emulate -L zsh
  [ $# -gt 0 ] || {
    echo "error: a host argument is required"
    return 1
  }
  local REMOTE=$1
  local PORT=${2:-443}
  echo | openssl s_client -showcerts -servername "$REMOTE" \
    -connect "$REMOTE:$PORT" 2>/dev/null | \
    openssl x509 -inform pem -noout -text
}

# print a pruned version of a tree
subtree() {
  tree -a --prune -P "$@"
}

# shell profiler
profile() {
  local shell=${1-$SHELL}
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

# try to run tmux with session management
tmux() {
  emulate -L zsh
  local SOCK_SYMLINK=~/.ssh/ssh_auth_sock
  [ -r "$SSH_AUTH_SOCK" ] && [ ! -L "$SSH_AUTH_SOCK" ] && \
    ln -sf "$SSH_AUTH_SOCK" "$SOCK_SYMLINK"
  [ $# -gt 0 ] && { env SSH_AUTH_SOCK=$SOCK_SYMLINK tmux "$@"; return; }
  if [ -x .tmux ]; then
    local DIGEST REPLY SESSION_NAME
    DIGEST="$(openssl dgst -sha512 .tmux)"
    grep -q "$DIGEST" "${TMUX_CONFIG_HOME}"/tmux.digests 2>/dev/null && { \
      ./.tmux; return; }
    cat .tmux
    read -k 1 -r \
      'REPLY?Trust (and run) this .tmux file? (t = trust, otherwise = skip) '
    echo
    [[ $REPLY =~ ^[Tt]$ ]] || {
      SESSION_NAME=$(basename ${${PWD}//[.:]/_})
      env SSH_AUTH_SOCK=$SOCK_SYMLINK tmux new -A -s "$SESSION_NAME"
      return
    }
    echo "$DIGEST" >>"${TMUX_CONFIG_HOME}"/tmux.digests
    ./.tmux
    return
  fi
  local SESSION_NAME
  SESSION_NAME=$(basename ${${PWD}//[.:]/_})
  env SSH_AUTH_SOCK=$SOCK_SYMLINK tmux new -A -s "$SESSION_NAME"
}

# traverse parent directories in a trivial manner
up() {
  [ $# -eq 0 ] && { cd ..; return; }
  local CDSTR=""
  for ((i=0; i<$1; i++)); do CDSTR="../$CDSTR"; done
  cd "$CDSTR" || exit
}

# define configuration path for vim
vim() {
  local MYVIMRC="${VIM_CONFIG_HOME}/vimrc"
  local __viminit=":set runtimepath+=${VIM_CONFIG_HOME},"
  __viminit+="${VIM_CONFIG_HOME}/after"
  is_darwin && __viminit+=",/usr/local/opt/fzf"
  __viminit+="|:source ${MYVIMRC}"
  local viminit="VIMINIT='$__viminit'"
  eval "$viminit command vim $*"
}

# poor man's wget runtime configuration
wget() {
  command wget --hsts-file "${XDG_CACHE_HOME}/wget/wget-hsts" "$@"
}

# poor man's yarn runtime configuration
yarn() {
  command yarn --use-yarnrc "${CONFIG_HOME}/yarn/config" "$@"
}

# hook override: add last executed command to histfile if return code is 0
precmd() {
  if [[ $? == 0 && -n $LASTHIST && -n $HISTFILE ]] ; then
    print -sr -- ${=${LASTHIST%%'\n'}}
  fi
}

# hook override: save executed commands to global variable instead of histfile
zshaddhistory() {
  LASTHIST=$1
  return 2
}
