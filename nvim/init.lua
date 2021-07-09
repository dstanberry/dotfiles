---------------------------------------------------------------
-- => Neovim Configuration
---------------------------------------------------------------
-- disable plugins if running vi
if vim.v.progname == "vi" then
  vim.opt.loadplugins = false
end

-- define a primary leader key
vim.g.mapleader = " "
-- define a secondary leader key
vim.g.maplocalleader = ","

local cache = vim.env.XDG_CACHE_HOME

-- ensure backup directory exists
local backup = cache .. "/nvim/backup"
if not vim.fn.isdirectory(backup) then
  vim.fn.mkdir(backup, "p")
end

-- ensure swap directory exists
local swap = cache .. "/nvim/swap"
if not vim.fn.isdirectory(swap) then
  vim.fn.mkdir(swap, "p")
end

-- ensure undo directory exists
local undo = cache .. "/nvim/undo"
if not vim.fn.isdirectory(undo) then
  vim.fn.mkdir(undo, "p")
end

-- ensure shada directory exists
local shada = cache .. "/nvim/shada"
if not vim.fn.isdirectory(shada) then
  vim.fn.mkdir(shada, "p")
end

-- ensure netrw directory exists
local netrw = cache .. "/nvim/netrw"
if not vim.fn.isdirectory(netrw) then
  vim.fn.mkdir(netrw, "p")
end

-- TODO: replace vim-plug with packer.nvim
-- lood remote plugins
vim.cmd [[ runtime autoload/plugins.vim ]]

-- lazy-load potentially expensive resources
vim.cmd [[ call functions#defer('call deferred#load_dir_hash()') ]]

-- extra lua configuration
require "startup"
