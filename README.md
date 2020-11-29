# Dotfiles

In a Linux environment, user-specific application configuration is traditionally stored in so called dotfiles (files whose filename starts with a dot). The schema is constructed such that it adheres to the XDG Base Directory Specification.

This configuration adopts what I think is a more elegant solution; the `.config` directory is maintained as a worktree linked to a git bare repository. To setup the environment, a number of one-time tasks will need to be executed:

```bash
# If desired, replace '$HOME/Git/dotfiles' with another location that is preferred.
working_dir=$HOME/Git/dotfiles
git clone --bare https://github.com/dstanberry/dotfiles $working_dir
git --git-dir=$working_dir --work-tree=$HOME/.config checkout
# Update .config/git/worktrees to ensure the value of $working_dir is the same.
```

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

Restart the shell/terminal for the changes to take effect.
