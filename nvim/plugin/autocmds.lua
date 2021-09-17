local util = require "util"

util.define_augroup {
  name = "command",
  clear = true,
  autocmds = {
    { event = "CmdLineEnter ", command = "set nosmartcase" },
    { event = "CmdLineLeave ", command = "set smartcase" },
  },
}

util.define_augroup {
  name = "ftdetect",
  clear = true,
  autocmds = {
    { event = { "BufRead", "BufNewFile" }, pattern = "*.asc,*.gpg,*.pgp", command = "setlocal filetype=text" },
    { event = { "BufRead", "BufNewFile" }, pattern = "*.vifm", command = "setlocal filetype=vim" },
    { event = { "BufRead", "BufNewFile" }, pattern = "dircolors", command = "setlocal filetype=sh" },
    { event = { "BufRead", "BufNewFile" }, pattern = "gitconfig", command = "setlocal filetype=.gitconfig" },
    { event = { "BufRead", "BufNewFile" }, pattern = "tmux.conf", command = "setlocal filetype=tmux" },
    { event = { "BufRead", "BufNewFile" }, pattern = "vifmrc", command = "setlocal filetype=vim" },
    { event = "BufEnter", pattern = "COMMIT_EDITMSG", command = "call setpos('.',[0, 1, 1, 0])" },
  },
}

util.define_augroup {
  name = "ftplugin",
  clear = true,
  autocmds = {
    { event = "Filetype", pattern = "asc", command = "setlocal nobackup noswapfile" },
    { event = "FileType", pattern = "bash", command = "setlocal expandtab shiftwidth=2" },
    { event = "FileType", pattern = "COMMIT_EDITMSG", command = "setlocal nobackup noswapfile noundofile" },
    { event = "FileType", pattern = "gitcommit", command = "setlocal nofoldenable spell" },
    { event = "FileType", pattern = "gitcommit", command = "startinsert" },
    { event = "Filetype", pattern = "gpg", command = "setlocal nobackup noswapfile" },
    { event = "FileType", pattern = "json", command = "setlocal expandtab shiftwidth=2" },
    { event = "FileType", pattern = "lua", command = "setlocal expandtab shiftwidth=2" },
    { event = "Filetype", pattern = "pgp", command = "setlocal nobackup noswapfile" },
    { event = "FileType", pattern = "python", command = "setlocal expandtab shiftwidth=2" },
    { event = "FileType", pattern = "python", command = "setlocal expandtab shiftwidth=2" },
    { event = "FileType", pattern = "sh", command = "setlocal expandtab shiftwidth=2" },
    {
      event = "FileType",
      pattern = "sql",
      command = "setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 shiftwidth=2 norelativenumber",
    },
    { event = "FileType", pattern = "vim", command = "setlocal expandtab shiftwidth=2 foldmethod=marker" },
    { event = "FileType", pattern = "zsh", command = "setlocal expandtab shiftwidth=2" },
  },
}

util.define_augroup {
  name = "yank_highlight",
  clear = true,
  autocmds = {
    {
      event = "TextYankPost",
      pattern = "*",
      command = [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})]],
    },
  },
}
