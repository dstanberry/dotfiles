---------------------------------------------------------------
-- => Neovim Configuration
---------------------------------------------------------------
-- define a primary leader key
vim.g.mapleader = " "
-- define a secondary leader key
vim.g.maplocalleader = ","

local cache = vim.env.XDG_CACHE_HOME

-- ensure backup directory exists
local backup = string.format("%s/nvim/backup", cache)
vim.fn.mkdir(backup, "p")

-- ensure swap directory exists
local swap = string.format("%s/nvim/swap", cache)
vim.fn.mkdir(swap, "p")

-- ensure undo directory exists
local undo = string.format("%s/nvim/undo", cache)
vim.fn.mkdir(undo, "p")

-- ensure shada directory exists
local shada = string.format("%s/nvim/shada", cache)
vim.fn.mkdir(shada, "p")

-- ensure netrw directory exists
local netrw = string.format("%s/nvim/netrw", cache)
vim.fn.mkdir(netrw, "p")

-- ensure packer.nvim is available
if not pcall(require, "packer") then
  require("util.packer").bootstrap()
  -- prevent anything else from loading
  return
end

-- load global functions
require "util.globals"

-- define colorscheme
R("ui.theme").setup()
-- define statusline
R("ui.statusline").setup()

-- load remote plugins
vim.defer_fn(function()
  require "remote.plugins"
end, 0)
