#!/usr/bin/env zsh
set -euo pipefail

ROCKS_PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/luarocks"

USER_ARGS=()
while [ $# -gt 0 ]; do
  [ "$1" = "--" ] && shift && break
  USER_ARGS+=("$1")
  shift
done
[ -n "${LUAROCKS_BUILD_ARGS:-}" ] && USER_ARGS+=(${=LUAROCKS_BUILD_ARGS})

command -v git >/dev/null 2>&1 || { echo "[ERR] git not found" >&2; exit 1; }
(command -v lua >/dev/null 2>&1 || command -v luajit >/dev/null 2>&1) || {
  echo "[ERR] lua 5.1 or luajit not found" >&2; exit 1; }

SOURCE_DIR=$(mktemp -d "${TMPDIR:-/tmp}/luarocks-src-XXXXXXXX")
cleanup() { [ -d "$SOURCE_DIR" ] && rm -rf -- "$SOURCE_DIR"; }
trap cleanup EXIT INT TERM
mkdir -p -- "$ROCKS_PREFIX"

git clone --filter=blob:none \
  https://github.com/luarocks/luarocks.git "$SOURCE_DIR" || {
  echo "[ERR] clone failed" >&2; exit 1; }
cd "$SOURCE_DIR"

CONFIGURE_ARGS=(
  "--prefix=$ROCKS_PREFIX" "--lua-version=5.1" "--force-config" "${USER_ARGS[@]}"
)
./configure "${CONFIGURE_ARGS[@]}" || {
  INCLUDE_DIRS=(/usr/include /usr/local/include)
  BP=$(command -v brew >/dev/null 2>&1 && brew --prefix 2>/dev/null || echo)
  [ -n "$BP" ] && [ -d "$BP/include" ] && INCLUDE_DIRS+=("$BP/include")
  for d in "${INCLUDE_DIRS[@]}"; do
    [ -d "$d" ] || continue
    ./configure "${CONFIGURE_ARGS[@]}" "--with-lua-include=$d" && break
  done
}
[ -f Makefile ] || { echo "[ERR] configure failed" >&2; exit 1; }

make -j"$(command -v nproc >/dev/null 2>&1 && nproc || echo 4)" >/dev/null
make install >/dev/null
mkdir -p -- "$HOME/.local/bin"
[ -x "$ROCKS_PREFIX/bin/luarocks" ] && ln -sf -- "$ROCKS_PREFIX/bin/luarocks" "$HOME/.local/bin/luarocks"
echo "[OK] luarocks installed at $ROCKS_PREFIX"
