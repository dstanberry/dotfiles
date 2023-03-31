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
    scm = "query",
    vifm = "vim",
    vifmrc = "vim",
    jenkinsfile = "groovy",
  },
  filename = {
    [".gitignore"] = "conf",
    ["tmux.conf"] = "tmux",
    jenkinsfile = "groovy",
  },
  pattern = {
    [".*/git/config"] = "gitconfig",
    [".*/git/gitconfig"] = "gitconfig",
  },
}

vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_logipat = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

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

vim.g.dotfiles_dir = vim.fn.expand(("%s/.config"):format(vim.env.HOME))
vim.g.projects_dir = vim.env.projects_dir and vim.fn.expand(vim.env.projects_dir)
  or vim.fn.expand(("%s/Projects"):format(vim.env.HOME))

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
    ui = { border = "none" },
  })
end
