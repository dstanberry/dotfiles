if vim.loader then vim.loader.enable() end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

_G.ds = require "util"

vim.filetype.add {
  extension = {
    jenkinsfile = "groovy",
    json = "jsonc",
    mdx = "markdown.mdx",
    vifm = "vim",
    vifmrc = "vim",
  },
  filename = {
    [".env"] = "sh",
    [".flake8"] = "toml",
    ["tmux.conf"] = "tmux",
    Brewfile = "ruby",
    jenkinsfile = "groovy",
  },
  pattern = {
    ["%.env%.[%w_.-]+"] = "sh",
    [".*/git/config"] = "gitconfig",
    [".*/git/gitconfig"] = "gitconfig",
    [".*/git/ignore"] = "gitignore",
    [".*/kitty/.+%.conf"] = "bash",
    [".*"] = {
      function(path, buf)
        return vim.bo[buf] ~= "bigfile" and path and vim.fn.getfsize(path) > 1024 * 1024 * 1.5 and "bigfile" or nil
      end,
    },
  },
}

local cache = vim.fn.stdpath "cache"
vim.fn.mkdir(vim.fs.joinpath(cache, "backup"), "p")
vim.fn.mkdir(vim.fs.joinpath(cache, "swap"), "p")
vim.fn.mkdir(vim.fs.joinpath(cache, "undo"), "p")
vim.fn.mkdir(vim.fs.joinpath(cache, "shada"), "p")

vim.cmd.colorscheme "kdark"
ds.color.sync_term_bg()

ds.fs.load_dirhash(vim.env.SHELL)
ds.fs.load_settings()

vim.g.dotfiles_dir = vim.fs.joinpath(vim.env.HOME, ".config")
vim.g.projects_dir = vim.env.projects_dir and vim.fs.normalize(vim.env.projects_dir)
  or vim.fs.joinpath(vim.env.HOME, "Projects")

ds.root.setup()
ds.plugin.setup()
