---------------------------------------------------------------
-- => Helper Functions
---------------------------------------------------------------
-- print inspection of variable
P = function(v)
  print(vim.inspect(v))
  return v
end

-- enable live-reloading of lua functions
if pcall(require, "plenary") then
  RELOAD = require("plenary.reload").reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

-- set mode specific global mapping
MAP = function(mode, key, f, options, vimchunk)
  local opts = options or { noremap = true, silent = true }
  local precmd = vimchunk and "" or "lua "
  local rhs = string.format("<cmd>%s%s<cr>", precmd, f)
  vim.api.nvim_set_keymap(mode, key, rhs, opts)
end

-- set mode specific buffer-local mapping
BMAP = function(bufnr, mode, key, f, options, vimchunk)
  local opts = options or { noremap = true, silent = true }
  local precmd = vimchunk and "" or "lua "
  local rhs = string.format("<cmd>%s%s<cr>", precmd, f)
  vim.api.nvim_buf_set_keymap(bufnr, mode, key, rhs, opts)
end

---------------------------------------------------------------
-- => Plugins
---------------------------------------------------------------
-- install packer.nvim if necessary
local download_packer = function()
  if vim.fn.input "Download Packer? (y for yes)" ~= "y" then
    return
  end

  local directory = string.format(
    "%s/site/pack/packer/start/",
    vim.fn.stdpath "data"
  )

  vim.fn.mkdir(directory, "p")

  local out = vim.fn.system(
    string.format(
      "git clone %s %s",
      "https://github.com/wbthomason/packer.nvim",
      directory .. "/packer.nvim"
    )
  )

  print(out)
  print "Downloading packer.nvim..."
  print "( You'll need to restart now )"
end

if not pcall(require, "packer") then
  download_packer()
  return
end

-- source plugin manager
require("plugins")

-- source plugins in lua/
require("startup.remote").source()
