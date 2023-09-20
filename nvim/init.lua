local util = require "util"
require "util.globals"

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.markdown_fenced_languages = {
  "bash=sh",
  "console=sh",
  "javascript",
  "js=javascript",
  "json",
  "lua",
  "python",
  "sh",
  "shell=sh",
  "ts=typescript",
  "typescript",
  "vim",
  "zsh=sh",
}

vim.filetype.add {
  extension = {
    jenkinsfile = "groovy",
    json = "jsonc",
    vifm = "vim",
    vifmrc = "vim",
  },
  filename = {
    ["tmux.conf"] = "tmux",
    Brewfile = "ruby",
    jenkinsfile = "groovy",
  },
  pattern = {
    [".*/git/config"] = "gitconfig",
    [".*/git/gitconfig"] = "gitconfig",
    [".*/git/ignore"] = "gitignore",
  },
}

local cache = vim.fn.stdpath "cache"
local backup = string.format("%s/backup", cache)
local swap = string.format("%s/swap", cache)
local undo = string.format("%s/undo", cache)
local shada = string.format("%s/shada", cache)

vim.fn.mkdir(backup, "p")
vim.fn.mkdir(swap, "p")
vim.fn.mkdir(undo, "p")
vim.fn.mkdir(shada, "p")

vim.cmd.colorscheme "kdark"

util.filesystem.load_dirhash(vim.env.SHELL)
util.filesystem.load_settings()

vim.g.dotfiles_dir = vim.fs.normalize(("%s/.config"):format(vim.env.HOME))
vim.g.projects_dir = vim.env.projects_dir and vim.fs.normalize(vim.env.projects_dir)
  or vim.fs.normalize(("%s/Projects"):format(vim.env.HOME))

if setting_enabled "remote_plugins" then
  local lazypath = string.format("%s/lazy/lazy.nvim", vim.fn.stdpath "data")
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup("remote", {
    root = string.format("%s/lazy", vim.fn.stdpath "data"),
    lockfile = string.format("%s/lua/remote/lazy-lock.json", vim.fn.stdpath "config"),
    ui = {
      border = "none",
      custom_keys = {
        ["<localleader>d"] = function(plugin) dump(plugin) end,
        ["<localleader>t"] = function(plugin)
          local cmd = has "win32" and "pwsh"
          require("lazy.util").float_term(cmd, {
            cwd = plugin.dir,
          })
        end,
      },
    },
    install = { missing = true },
    diff = { cmd = "terminal_git" },
    performance = {
      cache = { enabled = true },
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          -- "matchparen",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end
