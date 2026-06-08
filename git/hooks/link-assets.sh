#!/usr/bin/env bash
# Symlink every file under _assets/ into the mirrored path of a worktree.
# Idempotent: safe to re-run (ln -sf overwrites, mkdir -p is a no-op when the
# directory exists). Default target is $PWD; pass a worktree path to override,
# or --all to sync every worktree. Used with `git wt-sync` to cure drift on
# existing worktrees and optionally with `post-checkout` hook to configure new
# worktrees.
set -euo pipefail

BASEDIR=$(git rev-parse --path-format=absolute --git-common-dir)
ASSETS="$BASEDIR/_assets"

link_one() {
  local worktree="$1"
  while IFS= read -r -d '' src; do
    local rel="${src#"$ASSETS/"}"
    local dst="$worktree/$rel"
    mkdir -p "$(dirname "$dst")"
    ln -sfv "$src" "$dst"
  done < <(find "$ASSETS" -type f -print0)
}

if [[ ${1:-} == "--all" ]]; then
  git worktree list --porcelain | awk '/^worktree /{print $2}' \
    | while IFS= read -r wt; do
      [[ $wt == "${BASEDIR%/}" ]] && continue # skip the bare repo
      echo "Linking $wt"
      link_one "$wt"
    done
else
  link_one "${1:-$PWD}"
fi
