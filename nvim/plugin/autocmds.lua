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
  name = "ftplugin",
  clear = true,
  autocmds = {
    {
      event = "BufEnter",
      pattern = "COMMIT_EDITMSG",
      callback = function()
        vim.fn.setpos(".", { 0, 1, 1, 0 })
        vim.cmd [[startinsert]]
      end,
    },
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
      pattern = { "bash", "lua", "sh", "zsh" },
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
        vim.wo.spell = true
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
  name = "fold_behaviour",
  clear = true,
  autocmds = {
    {
      event = "BufEnter",
      callback = function()
        vim.wo.foldenable = false
        vim.wo.foldlevel = 99
        vim.wo.foldtext = "v:lua.fold_text()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.fold_expr(v:lnum)"
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
