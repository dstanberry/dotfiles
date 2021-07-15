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

-- resolve the location of lua-language-server binary
local sumneko_root_path = string.format("%s/lspconfig/sumneko_lua/lua-language-server", vim.fn.stdpath "cache")
local sumneko_binary = string.format("%s/bin/%s/lua-language-server", sumneko_root_path, system_name)

return luadev.setup {
  lspconfig = {
    cmd = { sumneko_binary, "-E", string.format("%s/main.lua", sumneko_root_path) },
  },
}
