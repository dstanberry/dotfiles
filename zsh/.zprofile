if [[ $(uname) == *"Darwin"* || $(uname) == *"darwin"* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export BREW_PREFIX="$(brew --prefix)"
  path=(
    "$BREW_PREFIX/opt/ruby/bin"
    "$BREW_PREFIX/lib/ruby/gems/3.0.0/bin"
    "$BREW_PREFIX/opt/coreutils/libexec/gnubin"
    $path
  )

  export MANPATH="$BREW_PREFIX/opt/coreutils/libexec/gnuman:${MANPATH}"
fi
