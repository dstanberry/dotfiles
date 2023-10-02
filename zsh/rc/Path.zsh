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
  echo "$P"
}

# add ruby gems to path if present
if hash gem 2> /dev/null; then
  NEWPATH=$NEWPATH:"$(_gem_config)"
fi

# add cargo binaries to path if present
if hash cargo 2> /dev/null; then
  CARGO="${CARGO_HOME:-$HOME/.local/share/cargo}/bin"
  NEWPATH=$CARGO:$NEWPATH
  unset CARGO
fi

# add go binaries to path if present
if hash go 2> /dev/null; then
  GO="${GOPATH:-$HOME/.local/share/go}/bin"
  NEWPATH=$GO:$NEWPATH
  unset GO
fi

# add lua binaries to path if present
if hash luarocks 2> /dev/null; then
  NEWPATH="$(luarocks path --lr-bin)":$NEWPATH
fi

# add lua binaries to path if present
if hash npm 2> /dev/null; then
  NPM="${XDG_DATA_HOME:-$HOME/.local/share}/npm/bin"
  NEWPATH=$NPM:$NEWPATH
  unset NPM
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
  # HACK: expose native specific Windows utils
  WIN="/mnt/c/Windows"
  SYS32="/mnt/c/Windows/System32"
  PWSH="/mnt/c/Windows/System32/WindowsPowerShell/v1.0"

  NEWPATH=$WIN:$SYS32:$PWSH:$NEWPATH
  unset WIN
  unset SYS32
  unset PWSH

  # HACK: bridge windows utils with qmk build environment
  ARM="${XDG_DATA_HOME:-$HOME/.local/share}/gnu-arm-none-eabi/bin"
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

export PATH=$NEWPATH
unset NEWPATH

# ensure no duplicate entries are present in PATH
dedup_pathvar PATH

# print the result so that it can be cached (by |evalcache|)
echo "export PATH=$PATH"
