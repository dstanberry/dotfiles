# Dotfiles

In a Linux environment, user-specific application configuration is traditionally stored in so called dotfiles (files whose filename starts with a dot). The schema is constructed such that it adheres to the XDG Base Directory Specification.

The glue required to make this possible is to tell the system wide bash configuration file where to look:

```bash
if [ -s "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc"
fi
```

Depending on the distro this file may exist in `/etc/bashrc`, `/etc/bash.bashrc` or `/etc/bash/bashrc`.

Optional: tell the global `.gitconfig` file to include this file:

```gitconfig
[include]
    path = .config/git/gitconfig
```
