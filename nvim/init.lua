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
    [".env"] = "dotenv",
    [".flake8"] = "toml",
    ["tmux.conf"] = "tmux",
    Brewfile = "ruby",
    jenkinsfile = "groovy",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "dotenv",
    [".*/git/config"] = "gitconfig",
    [".*/git/gitconfig"] = "gitconfig",
    [".*/git/ignore"] = "gitignore",
  },
}

local cache = vim.fn.stdpath "cache"
vim.fn.mkdir(vim.fs.joinpath(cache, "backup"), "p")
vim.fn.mkdir(vim.fs.joinpath(cache, "swap"), "p")
vim.fn.mkdir(vim.fs.joinpath(cache, "undo"), "p")
vim.fn.mkdir(vim.fs.joinpath(cache, "shada"), "p")

vim.cmd.colorscheme "kdark"
-- vim.cmd.colorscheme "catppuccin-frappe"

util.filesystem.load_dirhash(vim.env.SHELL)
util.filesystem.load_settings()

vim.g.dotfiles_dir = vim.fs.joinpath(vim.env.HOME, ".config")
vim.g.projects_dir = vim.env.projects_dir and vim.fs.normalize(vim.env.projects_dir)
  or vim.fs.joinpath(vim.env.HOME, "Projects")

require "util.lazy"
