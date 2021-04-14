#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Usage: $(basename "$0") [-f] destdir achieve.."
  echo '-f forces creation of nonexistent destdir'
  exit 1
fi

if [ "$1" = '-f' ]; then
  FORCE=1
  shift
else
  FORCE=0
fi

if [ -z "$1" ]; then
  OUTPUT=.
else
  OUTPUT="$1"
fi
shift

if [ ! -d "$OUTPUT" ]; then
  if [ -e "$OUTPUT" ]; then
    echo "'$OUTPUT' already exists and is not a directory"
    exit 1
  elif [ "$FORCE" != "0" ]; then
    mkdir -p "$OUTPUT"
  else
    echo "'$OUTPUT' doesn't exist"
    exit 1
  fi
fi

exitcode=0

for file; do
  if [ ! -f "$file" ]; then
    echo "'$file' is not a valid file"
    continue
  fi

  FULL=$(readlink -f "$file")

  cd "$OUTPUT" || return

  case "$file" in
    *.tar.bz2) tar xvjf "$FULL" ;;
    *.tar.gz) tar xvzf "$FULL" ;;
    *.bz2) bunzip2 "$FULL" ;;
    *.rar) unrar x "$FULL" ;;
    *.gz) gunzip "$FULL" ;;
    *.tar) tar xvf "$FULL" ;;
    *.tbz2) tar xvjf "$FULL" ;;
    *.tgz) tar xvzf "$FULL" ;;
    *.war) unzip "$FULL" ;;
    *.zip) unzip "$FULL" ;;
    *.Z) uncompress "$FULL" ;;
    *.7z) 7z x "$FULL" ;;
    *.tar.lzma) tar xf "$FULL" ;;
    *.tar.xz) tar xf "$FULL" ;;
    *) echo "'$file' cannot be extracted via this script"; exitcode=1 ;;
  esac

  cd "$OLDPWD" || return
done

exit $exitcode
