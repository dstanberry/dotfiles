# shellcheck disable=SC2148

# base directory for system-wide available scripts
ULOCAL="/usr/local/bin"
# include directory in PATH
NEWPATH=$ULOCAL:$PATH
unset ULOCAL

# define macOS specific paths
if is_darwin; then
  # cull existing visual studio code paths
  NEWPATH="$(echo $NEWPATH | tr : '\n' | grep -iv '/Applications/Visual' | paste -s -d: -)"

  # re-add vscode path with escaped whitesapce
  VSCODE="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin"
  NEWPATH=$NEWPATH:$VSCODE
  unset VSCODE

  # homebrew may install binaries here
  BREW="/usr/local/sbin"
  NEWPATH=$BREW:$NEWPATH
  unset BREW

  # include fzf
  FZF="/usr/local/opt/fzf/bin"
  NEWPATH=$FZF:$NEWPATH
  unset FZF

  # ensure homebrew binaries are available
  BP="${BREW_PREFIX:-/opt/homebrew}"
  B="$BP/bin"
  S="$BP/sbin"
  RUBY="$BP/opt/ruby/bin"
  RUBYGEM="$BP/lib/ruby/gems/3.0.0/bin"
  GNUBIN="$BP/opt/coreutils/libexec/gnubin"
  NEWPATH=$B:$S:$RUBY:$RUBYGEM:$GNUBIN:$NEWPATH
  echo "$(${BP}/bin/brew shellenv)"
  unset B 
  unset S 
  unset BP 
  unset RUBY
  unset RUBYGEM
  unset GNUBIN
fi

# define wsl specific paths
if is_wsl; then
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

# HACK: set default gem configuration options
_gem_config() {
  OLDIFS=$IFS
  IFS=:
  P=""
  for i in $(gem environment gempath); do
    if [ -d "$i/bin" ]; then
      P="$i/bin":$NEWPATH
    fi
    ud=$(gem env | grep 'USER INSTALLATION DIRECTORY' | awk -F':' '{ print $2 }')
    p="${ud##*/.gem/}"
    if [ -d "$i/$p/bin" ]; then
      P="$i/$p/bin":$NEWPATH
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
CARGO="${CARGO_HOME:-$HOME/.local/share/cargo}/bin"
if test -d "$CARGO" || hash cargo 2> /dev/null; then
  NEWPATH=$CARGO:$NEWPATH
fi
unset CARGO

# add dotnet installed tools to path if present
DOTNET_TOOLS="${XDG_DATA_HOME:-$HOME/.local/share}/dotnet/tools"
if test -d "$DOTNET_TOOLS" || hash dotnet 2> /dev/null; then
  NEWPATH=$DOTNET_TOOLS:$NEWPATH
fi
unset DOTNET_TOOLS

# add go binaries to path if present
GO="${GOPATH:-$HOME/.local/share/go}/bin"
if test -d "$GO" || hash go 2> /dev/null; then
  NEWPATH=$GO:$NEWPATH
fi
unset GO

# add lua binaries to path if present
if hash luarocks 2> /dev/null; then
  NEWPATH="$(luarocks path --lr-bin)":$NEWPATH
fi

# add npm binaries to path if present
if hash npm 2> /dev/null; then
  NPM="${XDG_DATA_HOME:-$HOME/.local/share}/npm/bin"
  NEWPATH=$NPM:$NEWPATH
  unset NPM
fi

# base directory for user local binaries
LOCAL="${HOME}/.local/bin"
NEWPATH=$LOCAL:$NEWPATH
unset LOCAL

# ensure no duplicate entries are present in PATH
dedup_pathvar NEWPATH
NEWPATH=$(echo "$NEWPATH" | sed 's/::/:/g')
echo "export PATH=$NEWPATH"
unset NEWPATH
