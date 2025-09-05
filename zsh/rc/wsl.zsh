if is_wsl && [[ "$EUID" -gt 0 ]] ; then
  # define the host IP address
  export HOST_IP="$(ip route | awk '/^default/{print $3}')"

  # define display server location
  export DISPLAY=:0

  # define default display server
  export GDK_BACKEND=wayland

  # https://gitlab.freedesktop.org/xorg/xserver/-/issues/1032
  # https://bugs.gentoo.org/721702
  # inform libglvnd of the opengl vendor
  # export __GLX_VENDOR_LIBRARY_NAME=mesa

  # define pulseaudio server location
  export PULSE_SERVER=/mnt/wslg/PulseServer

  # define wayland server location
  export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir

  # ensure X11 display socket exists
  if [ ! -L /tmp/.X11-unix ] && [ ! -d /tmp/.X11-unix ]; then
    ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix
  fi

  # define Xauthority location
  export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority

  # tell X server where to find cursors
  export XCURSOR_PATH="${XCURSOR_PATH:-$XDG_DATA_HOME/icons}"

  # tell X server what the cursor size should be
  export XCURSOR_SIZE=24

  # hand off opengl computation to remote X server
  # export LIBGL_ALWAYS_INDIRECT=1

  # set default dpi scale for applications
  export GDK_SCALE=1

  # announce kde configurations to qt apps
  export XDG_CURRENT_DESKTOP=KDE

  # disable QT GLX
  # export QT_XCB_GL_INTEGRATION=none

  # inform windows terminal of the current working directory
  update_current_path() {
    printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
  }
  typeset -a precmd_functions
  precmd_functions+=(update_current_path)
fi
