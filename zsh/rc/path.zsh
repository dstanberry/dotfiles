# shellcheck disable=SC2148

NEWPATH=$PATH

# base directory for system-wide available scripts
ULOCAL="/usr/local/bin"
# base directory for user local binaries
LOCAL="${HOME}/.local/bin"

# include directory in PATH
NEWPATH=$ULOCAL:$NEWPATH:$LOCAL
unset ULOCAL
unset LOCAL

# HACK: set default gem configuration options
function _gem_config() {
  OLDIFS=$IFS
  IFS=:
  P=""
  for i in $(gem environment gempath); do
    if [ -d "$i/bin" ]; then
      P="$i/bin":$PATH
    fi
    ud=$(gem env | grep 'USER INSTALLATION DIRECTORY' | awk -F':' '{ print $2 }')
    p="${ud##*/.gem/}"
    if [ -d "$i/$p/bin" ]; then
      P="$i/$p/bin":$PATH
    fi
  done
  IFS=$OLDIFS
  echo "export PATH=$P"
}

# add ruby gems to path if present
if hash gem 2> /dev/null; then
  _evalcache _gem_config
fi

# add cargo binaries to path if present
if hash cargo 2> /dev/null; then
  CARGO="${CARGO_HOME}/bin"
  NEWPATH=$CARGO:$NEWPATH
  unset CARGO
fi

# add go binaries to path if present
if hash go 2> /dev/null; then
  GO="${GOPATH}/bin"
  NEWPATH=$GO:$NEWPATH
  unset GO
fi

# add lua binaries to path if present
if hash luarocks 2> /dev/null; then
  _evalcache luarocks path
fi

# define macOS specific paths
if is_darwin; then
  # homebrew may install binaries here
  BREW="/usr/local/sbin"
  NEWPATH=$BREW:$NEWPATH
  unset BREW

  # include fzf
  FZF="/usr/local/opt/fzf/bin"
  NEWPATH=$FZF:$NEWPATH
  unset FZF
# define wsl specific paths
elif is_wsl; then
  # dirty hack to expose native specific Windows utils
  WIN="/mnt/c/Windows"
  SYS32="/mnt/c/Windows/System32"
  PWSH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0"

  NEWPATH=$WIN:$SYS32:$PWSH:$NEWPATH
  unset WIN
  unset SYS32
  unset PWSH

  # qmk hacks
  ARM="$XDG_DATA_HOME/gnu-arm-none-eabi/bin"
  QMK="$HOME/Git/qmk_distro_wsl/src/usr/bin"
  WBEM="/mnt/c/Windows/System32/Wbem"
  if test -e "$ARM"; then
    NEWPATH=$ARM:$NEWPATH
  fi
  if test -e "$QMK"; then
    NEWPATH=$QMK:$NEWPATH
  fi
  if test -e "$WBEM"; then
    NEWPATH=$WBEM:$NEWPATH
  fi
  unset ARM
  unset QMK
  unset WBEM
fi

# add pyenv binaries to path
if [ -d "${PYENV_ROOT}" ]; then
  PBIN="$PYENV_ROOT/bin"
  PSHIMS="$PYENV_ROOT/shims"
  NEWPATH=$PSHIMS:$PBIN:$NEWPATH
  unset PBIN
  unset PSHIMS
fi

export PATH=$NEWPATH
unset NEWPATH

# ensure no duplicate entries are present in PATH
dedup_pathvar PATH

# HACK: delay setting up pyenv until after PATH is reset
if [ -d "${PYENV_ROOT}" ]; then
  _evalcache pyenv init -
fi
