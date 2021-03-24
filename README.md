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
    path = .config/git/gitconfig
```

Restart the shell/terminal for the changes to take effect.

Dependencies
------------

[Delta](https://github.com/dandavison/delta); or

[diff-highlight](https://github.com/git/git/tree/master/contrib/diff-highlight) (perl script included in repo)

[RipGrep](https://github.com/BurntSushi/ripgrep); or

[Ack3](https://github.com/beyondgrep/ack3); or

[Ag](https://github.com/ggreer/the_silver_searcher)

[FZF](https://github.com/junegunn/fzf)

[Bat](https://github.com/sharkdp/bat)

[Vim](https://github.com/vim/vim) can be compiled with support for Lua, Perl, Python and Ruby.

[Neovim](https://github.com/neovim/neovim) supports remote plugins written in the same set of languages, but they need to be installed separately. Currently the necessary packages can be pulled in without too much effort.

Read through `scripts/packages/npm.txt`, `scripts/packages/pip.txt`, `scripts/packages/gem.txt` and remove delete any lines that contain unwanted packages before running any of the `load` commands.

- NodeJS
   - npm (should be installed with nodejs) `npm --version`

  Run `npm load` to install/update the files listed in `scripts/packages/npm.txt`
 
- Perl
   - _currently not in use_ 

- Python
   - pip (should be installed with Python) `python -m pip --version`
   - pipdeptree (required to manage package dependency graph) `pip install pipdeptree`

  Run `pip load` to install/update the files listed in `scripts/packages/pip.txt`
 
- Ruby
   - gem (should be installed with Ruby) `gem --version`

  Run `gem load` to install the files listed in `scripts/packages/gem.txt`
