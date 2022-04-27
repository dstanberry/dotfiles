pcall(require, "impatient")

local util = require "util"

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

vim.g.do_filetype_lua = 1
vim.g.did_load_filetype = 0

vim.filetype.add {
  extension = {
    scm = "query",
    vifm = "vim",
    vifmrc = "vim",
  },
  filename = {
    ["*/git/config"] = "gitconfig",
    ["gitconfig"] = "gitconfig",
    ["tmux.conf"] = "tmux",
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

vim.cmd "colorscheme base16-kdark"

util.reload("ui.statusline").setup()

require "util.globals"

vim.defer_fn(function()
  util.load_dirhash(vim.env.SHELL)
  if vim.fn.filereadable(vim.fn.expand "~/.hushremote") == 0 then
    pcall(require, "remote")
    pcall(require, "remote.packer_compiled")
  end
end, 0)
