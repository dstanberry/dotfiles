# Dotfiles

![neovim](https://github.com/dstanberry/dotfiles/wiki/assets/vim.png)

The schema is constructed such that it adheres to the XDG Base Directory
Specification.

The `.config` directory is maintained as a worktree linked to a git bare repository.
To setup the environment, a number of one-time tasks will need to be executed:

Clone the repository:

```bash
# If desired, replace '$HOME/Git/dotfiles' with another location that is preferred.
bare=$HOME/Git/dotfiles
worktree=$HOME/.config
git clone --bare https://github.com/dstanberry/dotfiles $bare
cd $bare
git worktree add $worktree $(git branch --show-current)
```

The glue required to make this possible is to tell the system wide configuration
file where to look for the user shell profile:

ZSH: This will need to be set in `/etc/zsh/zshenv`.

```zsh
export XDG_CONFIG_HOME="${HOME}/.config"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh/"
```

**_Note:_**

Machine specific settings can be defined within zsh/rc.private/ if
desired. The directory will be created automatically if it does not exist. In
particular during startup neovim will check if the current shell has a
file called `hashes.zsh` (depending on the running shell) and
will define each path as an environment variable within the editor.

```zsh
# (example content of hashes.zsh)
hash -d proj=/home/<user>/Projects/foo/bar
...
```

Git: Have the global `.gitconfig` file include the configurations
maintained here.

```gitconfig
[include]
    ; use this if config file is located at $XDG_CONFIG_HOME/git/config
    path = gitconfig
    ; or use the following if config file is located at $HOME/.gitconfig
    path = .config/git/gitconfig
```

Restart the shell/terminal for the changes to take effect.

Luarocks: In order to make luarocks partially compliant, edit
`/etc/luarocks/config-<version>.lua` and replace the user path with the
following:

<!-- markdownlint-disable MD013 -->

```lua
--rocks_trees = {
    { name = "user", root = (os_getenv("XDG_DATA_HOME") or (home .. '/.local/share')) .. "/luarocks" };
--  { name = "system", root = "/usr/share/lua/<version>" };
--}
```

Tmux: Must be on version >= 3.1 as 3.1 introduced checking for the configuration
file in `~/.config/tmux/tmux.conf` and in 3.2 `$XDG_CONFIG_HOME/tmux/tmux.conf`
is also checked.

## Dependencies

[Patched Font](https://www.nerdfonts.com)

[Bat](https://github.com/sharkdp/bat)

[RipGrep](https://github.com/BurntSushi/ripgrep)

[FZF](https://github.com/junegunn/fzf)

[Delta](https://github.com/dandavison/delta)

[Lazygit](https://github.com/jesseduffield/lazygit)

[Neovim](https://github.com/neovim/neovim)

## Extras

[shared/packages](https://github.com/dstanberry/dotfiles/blob/main/shared/packages)
contains text files in the format `<tool>.txt` whose contents are a lists of
packages that can be installed by executing `<tool> load`.
