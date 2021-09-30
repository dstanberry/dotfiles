---------------------------------------------------------------
-- => Neovim Configuration
---------------------------------------------------------------
-- define a primary leader key
vim.g.mapleader = " "
-- define a secondary leader key
vim.g.maplocalleader = ","

-- use proper syntax highlighting in code blocks
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

-- disable the following builtin plugins
local builtins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit",
}

for _, v in ipairs(builtins) do
  vim.g["loaded_" .. v] = 1
end

local cache = vim.env.XDG_CACHE_HOME
local backup = string.format("%s/nvim/backup", cache)
local swap = string.format("%s/nvim/swap", cache)
local undo = string.format("%s/nvim/undo", cache)
local shada = string.format("%s/nvim/shada", cache)

-- ensure backup directory exists
vim.fn.mkdir(backup, "p")
-- ensure swap directory exists
vim.fn.mkdir(swap, "p")
-- ensure undo directory exists
vim.fn.mkdir(undo, "p")
-- ensure shada directory exists
vim.fn.mkdir(shada, "p")

-- define colorscheme
vim.cmd "colorscheme base16-kdark"

-- define statusline
require("util").reload("ui.statusline").setup()

-- load global scope functions
require "util.globals"

-- load remote plugins
vim.defer_fn(function()
  require "remote"
  require("util").load_dirhash(vim.env.SHELL)
end, 0)
