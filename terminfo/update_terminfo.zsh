update_terminfo () {
  local x ncdir terms
  ncdir="/opt/homebrew/opt/ncurses"
  terms=(xterm xterm-new xterm+osc104 xterm-256color xterm+256color tmux tmux-256color)

  mkdir -p ~/.terminfo && cd ~/.terminfo

  if [ -d $ncdir ] ; then
    # sed : fix color for htop
    for x in $terms ; do
      $ncdir/bin/infocmp -x -A $ncdir/share/terminfo $x > ${x}.src &&
      sed -i '' 's|pairs#0x10000|pairs#32767|' ${x}.src &&
      /usr/bin/tic -x ${x}.src &&
      rm -f ${x}.src
    done
  else
    local url
    url="https://invisible-island.net/datafiles/current/terminfo.src.gz"
    if curl -sfLO $url ; then
      gunzip -f terminfo.src.gz &&
      sed -i 's|pairs#0x10000|pairs#32767|' terminfo.src &&
      /usr/bin/tic -xe ${(j:,:)terms} -o $HOME/.local/share/terminfo terminfo.src &&
      rm -f terminfo.src
    else
      echo "unable to download $url"
    fi
  fi
  cd - > /dev/null
}
