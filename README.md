Dotfiles
--------

The schema is constructed such that it adheres to the XDG Base Directory Specification.

This configuration adopts what I think is a more elegant solution; the `.config` directory is maintained as a worktree linked to a git bare repository. To setup the environment, a number of one-time tasks will need to be executed:

Clone the repository:

```bash
# If desired, replace '$HOME/Git/dotfiles' with another location that is preferred.
working_dir=$HOME/Git/dotfiles
git clone --bare https://github.com/dstanberry/dotfiles $working_dir
git --git-dir=$working_dir --work-tree=$HOME/.config checkout
# Update .config/git/worktrees to ensure the value of $working_dir is the same.
```

The glue required to make this possible is to tell the system wide configuration file where to look for the user shell profile:

Bash:
Depending on the distro this file may exist in `/etc/bashrc`, `/etc/bash.bashrc` or `/etc/bash/bashrc`.

```bash
if [ -s "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/bash/bashrc"
fi
```

ZSH:
This will need to be set in `/etc/zsh/zshenv`.

```zsh
export XDG_CONFIG_HOME="${HOME}/.config"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh/"
```

Git (Optional):
Have the global `.gitconfig` file include the configurations maintained here.

```gitconfig
[include]
    ; use this if config file is located at $XDG_CONFIG_HOME/git/config
    path = gitconfig
    ; or use the following if config file is located at $HOME/.gitconfig
    path = .config/git/gitconfig
```

Restart the shell/terminal for the changes to take effect.

Luarocks:
In order to make luarocks partially compliant, edit `/etc/luarocks/config-<version>.lua` and replace the user path with the following:
```lua
--rocks_trees = {
    { name = "user", root = (os_getenv("XDG_DATA_HOME") or (home .. '/.local/share')) .. "/luarocks" };
--  { name = "system", root = "/usr/share/lua/<version>" };
--}
```

Tmux: Must be on version >= 3.1 as 3.1 introduced checking for the configuration file in `~/.config/tmux/tmux.conf` and in 3.2 `$XDG_CONFIG_HOME/tmux/tmux.conf` is also checked.

Dependencies
------------

[Delta](https://github.com/dandavison/delta) or [diff-highlight](https://github.com/git/git/tree/master/contrib/diff-highlight) (perl script included in repo)

[RipGrep](https://github.com/BurntSushi/ripgrep) or [Ag](https://github.com/ggreer/the_silver_searcher) or [Ack3](https://github.com/beyondgrep/ack3)

[FZF](https://github.com/junegunn/fzf)

[Bat](https://github.com/sharkdp/bat) (required by delta and fzf)

[Patched Font](https://www.nerdfonts.com)

[Vim](https://github.com/vim/vim) can be compiled with support for Lua, Perl, Python and Ruby.

[Neovim (nightly)](https://github.com/neovim/neovim) supports remote plugins written in the same set of languages, but they need to be installed separately. Currently the necessary packages can be pulled in without too much effort.

Read through all the txt files in `shared/packages` and remove delete any lines that contain unwanted packages before running any of the `load` commands.

- Cargo
  - install rust through package manager or [manually](https://doc.rust-lang.org/cargo/getting-started/installation.html)
  - Run `cargo load` to install/update the files listed in `scripts/packages/cargo.txt`

- Go
  - install through package manager
  - Run `go load` to install/update the files listed in `scripts/packages/go.txt`

- Luarocks
  - install through package manager
  - Run `luarocks load` to install/update the files listed in `scripts/packages/luarocks.txt`

- NodeJS
  - npm (should be installed with nodejs otherwise install through package manager) `npm --version`
  - If npm is installed, the following will be enforced in npm's configuration file:
    ```
    prefix=${XDG_DATA_HOME}/npm
    cache=${XDG_CACHE_HOME}/npm
    tmp=${XDG_RUNTIME_DIR}/npm
    init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
    ```
  - Run `npm load` to install/update the files listed in `scripts/packages/npm.txt`
- Perl
  - _currently not in use_ 
- Python
  - pip (should be installed with Python) `python -m pip --version`
  - pipdeptree (required to manage package dependency graph) `pip install pipdeptree`
  - Run `pip load` to install/update the files listed in `scripts/packages/pip.txt`
- Ruby
  - gem (should be installed with Ruby) `gem --version`
  - Run `gem load` to install the files listed in `scripts/packages/gem.txt`
