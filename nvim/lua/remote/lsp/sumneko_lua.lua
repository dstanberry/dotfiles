---------------------------------------------------------------
-- => (sumneko) lua-language-server configuration
---------------------------------------------------------------
-- ensure lua-dev is available
local ok, luadev = pcall(require, "lua-dev")
if not ok then
  return {}
end

-- set the path to the sumneko installation
local sumneko_root_path = string.format("%s/lspconfig/sumneko_lua/lua-language-server", vim.fn.stdpath "cache")
local sumneko_binary = string.format("%s/bin/%s/lua-language-server", sumneko_root_path, system_name)

return luadev.setup {
  lspconfig = {
    cmd = { sumneko_binary, "-E", string.format("%s/main.lua", sumneko_root_path) },
  },
}
