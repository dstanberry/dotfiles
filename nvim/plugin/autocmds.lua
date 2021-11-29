local util = require "util"

util.define_augroup {
  name = "cmdline",
  clear = true,
  autocmds = {
    {
      event = "CmdLineEnter",
      callback = function()
        vim.opt.smartcase = false
      end,
    },
    {
      event = "CmdLineLeave",
      callback = function()
        vim.opt.smartcase = true
      end,
    },
  },
}

util.define_augroup {
  name = "ftdetect",
  clear = true,
  autocmds = {
    {
      event = { "BufRead", "BufNewFile" },
      pattern = { "*.asc", "*.gpg", "*.pgp" },
      callback = function()
        vim.bo.filetype = "text"
      end,
    },
    {
      event = { "BufRead", "BufNewFile" },
      pattern = "*.scm",
      callback = function()
        vim.bo.filetype = "query"
      end,
    },
    {
      event = { "BufRead", "BufNewFile" },
      pattern = { "*.vifm", "vifmrc" },
      callback = function()
        vim.bo.filetype = "vim"
      end,
    },
    {
      event = { "BufRead", "BufNewFile" },
      pattern = "dircolors",
      callback = function()
        vim.bo.filetype = "sh"
      end,
    },
    {
      event = { "BufRead", "BufNewFile" },
      pattern = "gitconfig",
      callback = function()
        vim.bo.filetype = "gitconfig"
      end,
    },
    {
      event = "BufEnter",
      pattern = "COMMIT_EDITMSG",
      callback = function()
        vim.fn.setpos(".", { 0, 1, 1, 0 })
        vim.cmd [[startinsert]]
      end,
    },
  },
}

util.define_augroup {
  name = "ftplugin",
  clear = true,
  autocmds = {
    {
      event = "Filetype",
      callback = function()
        vim.bo.formatoptions = "cjlnqr"
      end,
    },
    {
      event = "Filetype",
      pattern = { "asc", "gpg", "pgp" },
      callback = function()
        vim.bo.backup = false
        vim.bo.swapfile = false
      end,
    },
    {
      event = "FileType",
      pattern = { "bash", "javascript", "json", "lua", "python", "sh", "zsh" },
      callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
      end,
    },
    {
      event = "FileType",
      pattern = "COMMIT_EDITMSG",
      callback = function()
        vim.bo.backup = false
        vim.bo.spell = true
        vim.bo.swapfile = false
        vim.bo.undofile = false
        vim.wo.foldenable = false
      end,
    },
    {
      event = "FileType",
      pattern = "sql",
      callback = function()
        vim.bo.expandtab = true
        vim.bo.relativenumber = false
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.tabstop = 2
      end,
    },
    {
      event = "FileType",
      pattern = "vim",
      callback = function()
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.wo.foldmethod = "marker"
      end,
    },
  },
}

util.define_augroup {
  name = "terminal_ui",
  clear = true,
  autocmds = {
    {
      event = "TermOpen",
      callback = function()
        vim.wo.relativenumber = false
        vim.wo.number = false
      end,
    },
  },
}

util.define_augroup {
  name = "yank_highlight",
  clear = true,
  autocmds = {
    {
      event = "TextYankPost",
      callback = vim.highlight.on_yank,
    },
  },
}
