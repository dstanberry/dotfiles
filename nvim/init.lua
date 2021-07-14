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
if not vim.fn.isdirectory(backup) then
  vim.fn.mkdir(backup, "p")
end

-- ensure swap directory exists
local swap = string.format("%s/nvim/swap", cache)
if not vim.fn.isdirectory(swap) then
  vim.fn.mkdir(swap, "p")
end

-- ensure undo directory exists
local undo = string.format("%s/nvim/undo", cache)
if not vim.fn.isdirectory(undo) then
  vim.fn.mkdir(undo, "p")
end

-- ensure shada directory exists
local shada = string.format("%s/nvim/shada", cache)
if not vim.fn.isdirectory(shada) then
  vim.fn.mkdir(shada, "p")
end

-- ensure netrw directory exists
local netrw = string.format("%s/nvim/netrw", cache)
if not vim.fn.isdirectory(netrw) then
  vim.fn.mkdir(netrw, "p")
end

-- lazy-load potentially expensive resources
vim.cmd [[ call functions#defer('call deferred#load_dir_hash()') ]]

-- extra lua configuration (loads globals and remote plugin configurations)
require "startup"

-- define colorscheme
R("colorscheme").setup()
-- define statusline contents
R("statusline").setup()
