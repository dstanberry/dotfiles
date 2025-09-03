#!/usr/bin/env zsh

set -euo pipefail

# ---------------------------
# Configuration / Arguments
# ---------------------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${(%):-%N}")" && pwd)"
PLUGIN_ROOT="${PLUGIN_ROOT:-$SCRIPT_DIR}"
ROCKS_DIR="$PLUGIN_ROOT/.rocks"

# Extra configure args can come from:
# 1. Command line
# 2. Environment variable LUAROCKS_BUILD_ARGS (space-separated)
typeset -a EXTRA_ARGS
EXTRA_ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --) shift; break ;;
    *)  EXTRA_ARGS+=("$1") ;;
  esac
  shift
done
if [[ -n "${LUAROCKS_BUILD_ARGS:-}" ]]; then
  EXTRA_ARGS+=(${(z)LUAROCKS_BUILD_ARGS})
fi

# Workaround include dirs attempted if configure fails
typeset -a INCLUDE_WORKAROUNDS
INCLUDE_WORKAROUNDS=(
  "/usr/include"
  "/usr/local/include"
)
if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
  [[ -d "$BREW_PREFIX/include" ]] && INCLUDE_WORKAROUNDS+=("$BREW_PREFIX/include")
fi

# ---------------------------
# Logging Helpers
# ---------------------------
log_info()    { print -- "[INFO] $*"; }
log_success() { print -- "[ OK ] $*"; }
log_error()   { print -- "[ERR] $*" >&2; }

fail() {
  log_error "$*"
  exit 1
}

# ---------------------------
# Preconditions
# ---------------------------
check_cmd() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command '$1' not found."
  log_success "Found $1"
}

log_info "Starting luarocks build process"

check_cmd git
if command -v lua >/dev/null 2>&1; then
  LUA_BIN=lua
elif command -v luajit >/dev/null 2>&1; then
  LUA_BIN=luajit
else
  fail "Neither 'lua' nor 'luajit' found. Install Lua 5.1 or LuaJIT."
fi
log_success "Using $LUA_BIN"

# ---------------------------
# Prepare temporary directory
# ---------------------------
TMPDIR_ROOT="${TMPDIR:-/tmp}"
TEMP_DIR="$(mktemp -d "$TMPDIR_ROOT/luarocks-src-XXXXXXXX")"
cleanup() {
  [[ -d "$TEMP_DIR" ]] && rm -rf -- "$TEMP_DIR"
}
trap cleanup EXIT INT TERM

mkdir -p -- "$ROCKS_DIR"

# ---------------------------
# Clone luarocks
# ---------------------------
log_info "Cloning luarocks repository"
if ! git clone --filter=blob:none https://github.com/luarocks/luarocks.git "$TEMP_DIR"; then
  fail "Failed to clone luarocks (check network connectivity)."
fi
log_success "Repository cloned"

cd -- "$TEMP_DIR"

# ---------------------------
# Configure (Unix-like only)
# ---------------------------
OS_NAME="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS_NAME" in
  *mingw*|*msys*|*cygwin*)
    fail "Windows install via this zsh script is not supported. Use the plugin's native build mechanism."
    ;;
esac

run_configure() {
  log_info "Running ./configure $*"
  if ./configure "$@"; then
    log_success "Configure succeeded"
    return 0
  fi
  return 1
}

BASE_CONFIG_ARGS=(
  "--prefix=$ROCKS_DIR"
  "--lua-version=5.1"
  "--force-config"
)
ALL_ARGS=("${BASE_CONFIG_ARGS[@]}" "${EXTRA_ARGS[@]}")

if ! run_configure "${ALL_ARGS[@]}"; then
  log_info "Primary configure failed; attempting include path workarounds"
  for inc in "${INCLUDE_WORKAROUNDS[@]}"; do
    [[ -d "$inc" ]] || continue
    if run_configure "${ALL_ARGS[@]}" "--with-lua-include=$inc"; then
      CONFIG_OK=1
      break
    fi
  done
  [[ "${CONFIG_OK:-0}" -eq 1 ]] || fail "All configure attempts failed."
fi

# ---------------------------
# Build & Install
# ---------------------------
log_info "Running make"
make -j"$(command -v nproc >/dev/null 2>&1 && nproc || echo 4)" >/dev/null
log_success "make completed"

log_info "Running make install"
make install >/dev/null
log_success "make install completed"

# ---------------------------
# Finalization
# ---------------------------
log_success "luarocks build completed successfully"
log_info "Installed into: $ROCKS_DIR"
exit 0