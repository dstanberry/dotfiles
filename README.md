# Dotfiles

In a Linux environment, user-specific application configuration is traditionally stored in so called dotfiles (files whose filename starts with a dot). The schema is constructed such that it adheres to the XDG Base Directory Specification.

The glue required to make this possible is to tell the system wide configuration file where to look for the user shell profile:

Bash:

```bash
if [ -s "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc"
fi
```

Depending on the distro this file may exist in `/etc/bashrc`, `/etc/bash.bashrc` or `/etc/bash/bashrc`.

ZSH:

```zsh
export XDG_CONFIG_HOME="${HOME}/.config"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh/"
```

This will need to be set in `/etc/zsh/zshenv`

Optional: tell the global `.gitconfig` file to include this file:

```gitconfig
[include]
    path = .config/git/gitconfig
```
