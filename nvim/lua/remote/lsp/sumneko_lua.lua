---------------------------------------------------------------
-- => (sumneko) lua-language-server configuration
---------------------------------------------------------------
-- determine operating system
local system_name
if vim.fn.has "mac" == 1 then
  system_name = "macOS"
elseif vim.fn.has "unix" == 1 then
  system_name = "Linux"
elseif vim.fn.has "win32" == 1 then
  system_name = "Windows"
else
  print "Unsupported system for sumneko"
  return
end

-- ensure lua-dev is available
local ok, luadev = pcall(require, "lua-dev")
if not ok then
  return {}
end

-- set the path to the sumneko installation
local sumneko_root_path = string.format("%s/lspconfig/sumneko_lua/lua-language-server", vim.fn.stdpath "cache")
local sumneko_binary = string.format("%s/bin/%s/lua-language-server", sumneko_root_path, system_name)

local setup = luadev.setup {
  lspconfig = {
    cmd = { sumneko_binary, "-E", string.format("%s/main.lua", sumneko_root_path) },
  },
}

-- ensure that the local nvim configuration is available
local lua_settings = setup.settings.Lua
lua_settings.workspace.library = require("lua-dev.sumneko").library()

local function add(lib)
  for _, p in pairs(vim.fn.expand(lib, false, true)) do
    p = vim.loop.fs_realpath(p)
    lua_settings.workspace.library[p] = true
  end
end

-- add runtime
add "$VIMRUNTIME"
-- add local plugins
add "~/.config/nvim"
-- add remote plugins
local directory = string.format("%s/site/pack/packer", vim.fn.stdpath "data")
local plugindir = vim.fn.expand(directory)
add(string.format("%s/opt/*", plugindir))
add(string.format("%s/start/*", plugindir))

return setup
