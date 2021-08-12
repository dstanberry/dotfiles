# add ruby gems to path if present
if hash gem 2> /dev/null; then
  OLDIFS=$IFS
  IFS=:
  for i in $(gem environment gempath); do
    if [ -d "$i/bin" ]; then
      export PATH="$i/bin":$PATH
    fi
    ud=$(gem env | grep 'USER INSTALLATION DIRECTORY' | awk -F':' '{ print $2 }')
    p="${ud##*/.gem/}"
    if [ -d "$i/$p/bin" ];then
      export PATH="$i/$p/bin":$PATH
    fi
  done
  IFS=$OLDIFS
fi

# add cargo binaries to path if present
if hash cargo 2> /dev/null; then
  CARGO="${CARGO_HOME}/bin"
  export PATH=$CARGO:$PATH
  unset CARGO
fi

# add go binaries to path if present
if hash go 2> /dev/null; then
  GO="${GOPATH}/bin"
  export PATH=$GO:$PATH
  unset GO
fi

# add lua binaries to path if present
if hash luarocks 2> /dev/null; then
  eval "$(luarocks path)"
fi

# base directory for system-wide available scripts
ULOCAL="/usr/local/bin"
# base directory for user local binaries
LOCAL="${HOME}/.local/bin"

# include directory in PATH
export PATH=$ULOCAL:$PATH:$LOCAL
unset ULOCAL
unset LOCAL

# define macOS specific paths
if is_darwin; then
  # homebrew may install binaries here
  BREW="/usr/local/sbin"
  export PATH=$BREW:$PATH
  unset BREW

  # include fzf
  FZF="/usr/local/opt/fzf/bin"
  export PATH=$FZF:$PATH
  unset FZF
  # define wsl specific paths
elif is_wsl; then
  # dirty hack to expose native specific Windows utils
  WIN="/mnt/c/Windows"
  SYS32="/mnt/c/Windows/System32"
  PWSH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0"

  export PATH=$WIN:$SYS32:$PWSH:$PATH
  unset WIN
  unset SYS32
  unset PWSH
fi

# add pyenv binaries to path
if [ -d "${PYENV_ROOT}" ]; then
  PYENVPATH="$PYENV_ROOT/bin"
  export PATH=$PYENVPATH:$PATH
  eval "$(pyenv init --path)"
  unset PYENVPATH
fi

# ensure no duplicate entries are present in PATH
dedup_pathvar PATH
