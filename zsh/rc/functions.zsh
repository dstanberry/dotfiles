# shellcheck disable=SC2148

# support custom sub-commands
cargo() {
  local PKG=$CONFIG_HOME/shared/packages/cargo.txt
  if is_darwin; then
    PKG=$CONFIG_HOME/shared/packages/cargo-macos.txt
  fi
  if [ "$1" = "save" ]; then
    command cargo install --list | grep -E '^\w+' | awk '{ print $1 }' > "$PKG"
  elif [ "$1" = "load" ]; then
    if [ "$EUID" -eq 0 ]; then
      echo "cargo load is not supported for root user"
      exit 1
    fi
    < "$PKG" xargs "cargo" install
  else
    command cargo "$@"
  fi
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

# use side-by-side diff view if shell width is large enough
delta() {
  if [[ -n "$COLUMNS" ]] && [[ "$COLUMNS" -gt 200 ]]; then
    command delta --side-by-side --width "$COLUMNS" $@
  else
    command delta $@
  fi
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
  if [ "$1" = "load" ]; then
    if [ "$EUID" -eq 0 ]; then
      echo "gem load is not supported for root user"
      exit 1
    fi
    < "$PKG" xargs "gem" install
  else
    command gem "$@"
  fi
}

# support custom sub-commands
git() {
  emulate -L zsh
  local git_root wt_path
  if [ "$1" = "fstash" ]; then
    gstash
  elif [ "$1" = "wta" ]; then
    local branches=("${(@f)$(git branch | cut -c 3-)}")
    git_root=$(command git rev-parse --path-format=absolute --git-common-dir)
    dir_name="${2//\//-}"
    wt_path="$git_root/$dir_name"
    if (($branches[(Ie)$2])); then
      command git worktree add "$wt_path" "$2"
    else
      command git worktree add -b "$2" "$wt_path"
    fi
    [ -d "$wt_path" ] && cd $wt_path
  elif [ "$1" = "wtl" ]; then
    wt_path=$(git worktree list \
      | fzf --exit-0 --no-multi \
		--header="Switch worktree" \
		--preview="git graph -50 --color=always" \
      | awk '{print $1}')
    [ -d "$wt_path" ] && cd $wt_path
  elif [ "$1" = "track-remote" ]; then
    command git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  else
    command git "$@"
  fi
}

# support custom sub-commands
go() {
  local PKG=$CONFIG_HOME/shared/packages/go.txt
  if is_darwin; then
    PKG=$CONFIG_HOME/shared/packages/go-macos.txt
  fi
  if [ "$1" = "load" ]; then
    if [ "$EUID" -eq 0 ]; then
      echo "go load is not supported for root user"
      exit 1
    fi
    # < "$PKG" xargs "go" install
    while read -r line
    do
      go install "$line"
    done < "$PKG"
  else
    command go "$@"
  fi
}

# simplistic git-stash management
# |enter| shows the contents of the stash
# |alt-b| checks the stash out as a branch, for easier merging
# |alt-d| shows a diff of the stash against your current HEAD
# |alt-s| populates the command line with the command to drop the stash
gstash() {
  local out q k ref sha
  while stash=$(
    git stash list \
      --pretty="%C(auto)%gD%Creset %C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs%Creset" |
    fzf --ansi --no-sort --query="$q" --print-query \
      --header "alt-b: apply selected, alt-d: see diff, alt-s: drop selected" \
      --preview "git stash show -p {1} --color=always" \
    --expect=alt-b,alt-d,alt-s,enter);
  do
    out=(${(f)"$(echo "$stash")"})
    q="${out[1]}"
    k="${out[2]}"
    ref="${out[3]}"
    ref="${ref%% *}"
    sha="${out[3]}"
    sha="${sha#refs* }"
    sha="${sha%% *}"
    [[ -z "$ref" || -z "$sha" ]] && continue
    if [[ "$k" == 'alt-b' ]]; then
      git stash branch "stash-$sha" "$sha"
      break;
    elif [[ "$k" == 'alt-d' ]]; then
      git diff "$sha"
      break;
    elif [[ "$k" == 'alt-s' ]]; then
      print -z "git stash drop $ref"
      break
    else
      git stash show -p "$sha"
    fi
  done
}

# print response headers, following redirects.
headers() {
  if [ $# -ne 1 ]; then
    echo "error: a host argument is required"
    return 1
  fi
  local REMOTE=$1
  curl -sSL -D - "$REMOTE" -o /dev/null
}

# support custom sub-commands
luarocks() {
  local PKG=$CONFIG_HOME/shared/packages/luarocks.txt
  if [ "$1" = "load" ]; then
    if [ "$EUID" -eq 0 ]; then
      echo "luarocks load is not supported for root user"
      exit 1
    fi
    < "$PKG" xargs "luarocks" --tree="${XDG_DATA_HOME}/luarocks" install
  else
    command luarocks "$@"
  fi
}

# custom |zk| wrapper
notes() {
  emulate -L zsh
  if [ $# -eq 0 ] || [ "$1" = "list" ]; then
    zk list
  elif [ "$1" = "edit" ]; then
    zk edit --interactive
  elif [ "$1" = "new" ]; then
    local dir=$(fd . "$ZK_NOTEBOOK_DIR" \
      --type d \
      --exclude '.zk' \
      -X printf '%s\n' {/} \
      | fzf --exit-0 --no-multi \
        --header 'Create note within:' \
        --bind 'focus:transform-header(echo Create note within {1})' \
        --preview '(eza -lh --icons $ZK_NOTEBOOK_DIR/{1} ||
        ls -lh $ZK_NOTEBOOK_DIR/{1}) 2> /dev/null')
    if [ "$dir" = "" ]; then
      exit 0
    fi
    local title=""
    vared -p 'Note title: ' title
    zk new "${dir}" --title "$title"
  fi
}

# support custom sub-commands
npm() {
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
      echo "npm load is not supported for root user"
      exit 1
    fi
    < "$PKG" xargs "npm" install -g
  else
    command npm "$@"
  fi
}

# set npm default configuration options
_npm_config() {
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
  # print some arbitrary result so that it can be cached (by |evalcache|)
  echo "NPM_CONFIG_USERPREFIX=$_prefix"
}
_evalcache _npm_config

# poor man's rg runtime configuration
rg() {
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
  ssl() {
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
  up() {
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
  vim() {
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
