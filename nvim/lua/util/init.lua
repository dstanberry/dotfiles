---------------------------------------------------------------
-- => Helper Functions
---------------------------------------------------------------
-- print inspection of variable
_G.P = function(...)
  print(vim.inspect(...))
end

-- enable live-reloading of lua functions
if pcall(require, "plenary") then
  _G.RELOAD = require("plenary.reload").reload_module

  -- live reload lua functions
  _G.R = function(name)
    RELOAD(name)
    return require(name)
  end
end

-- initialize modules table
local M = {}

M.functions = {}

local map = function(mode, key, cmd, opts, defaults)
  opts = vim.tbl_deep_extend("force", { silent = true }, defaults or {}, opts or {})

  if type(cmd) == "function" then
    table.insert(M.functions, cmd)
    if opts.expr then
      cmd = ([[luaeval('require("util").execute(%d)')]]):format(#M.functions)
    else
      cmd = ("<cmd>lua require('util').execute(%d)<cr>"):format(#M.functions)
    end
  end
  if opts.buffer ~= nil then
    local buffer = opts.buffer
    opts.buffer = nil
    return vim.api.nvim_buf_set_keymap(buffer, mode, key, cmd, opts)
  else
    return vim.api.nvim_set_keymap(mode, key, cmd, opts)
  end
end

function M.execute(id)
  local func = M.functions[id]
  if not func then
    error("Function doest not exist: " .. id)
  end
  return func()
end

function M.map(mode, key, cmd, opt, defaults)
  return map(mode, key, cmd, opt, defaults)
end

function M.nmap(key, cmd, opts)
  return map("n", key, cmd, opts)
end
function M.vmap(key, cmd, opts)
  return map("v", key, cmd, opts)
end
function M.xmap(key, cmd, opts)
  return map("x", key, cmd, opts)
end
function M.imap(key, cmd, opts)
  return map("i", key, cmd, opts)
end
function M.omap(key, cmd, opts)
  return map("o", key, cmd, opts)
end
function M.smap(key, cmd, opts)
  return map("s", key, cmd, opts)
end

function M.nnoremap(key, cmd, opts)
  return map("n", key, cmd, opts, { noremap = true })
end
function M.vnoremap(key, cmd, opts)
  return map("v", key, cmd, opts, { noremap = true })
end
function M.xnoremap(key, cmd, opts)
  return map("x", key, cmd, opts, { noremap = true })
end
function M.inoremap(key, cmd, opts)
  return map("i", key, cmd, opts, { noremap = true })
end
function M.onoremap(key, cmd, opts)
  return map("o", key, cmd, opts, { noremap = true })
end
function M.snoremap(key, cmd, opts)
  return map("s", key, cmd, opts, { noremap = true })
end

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.log(msg, hl, name)
  name = name or "Neovim"
  hl = hl or "Todo"
  vim.api.nvim_echo({ { name .. ": ", hl }, { msg } }, true, {})
end

function M.warn(msg, name)
  M.log(msg, "LspDiagnosticsDefaultWarning", name)
end

function M.error(msg, name)
  M.log(msg, "LspDiagnosticsDefaultError", name)
end

function M.info(msg, name)
  M.log(msg, "LspDiagnosticsDefaultInformation", name)
end

-- install packer.nvim
function M.packer_bootstrap()
  if vim.fn.input "Download Packer? (y for yes)" ~= "y" then
    return
  end
  local directory = string.format("%s/site/pack/packer/start/", vim.fn.stdpath "data")
  vim.fn.mkdir(directory, "p")
  local out = vim.fn.system(
    string.format("git clone %s %s", "https://github.com/wbthomason/packer.nvim", directory .. "/packer.nvim")
  )
  M.info(out)
  M.info "Downloading packer.nvim..."
  M.info "( Restart is required! )"
end

return M