-- verify lua-dev is available
local ok, luadev = pcall(require, "lua-dev")
if not ok then
  return {}
end

local system_name
if vim.fn.has "mac" == 1 then
  system_name = "macOS"
elseif vim.fn.has "unix" == 1 then
  system_name = "Linux"
else
  print "Unsupported system for sumneko"
  return
end

local sumneko_root_path = string.format("%s/lspconfig/sumneko_lua/lua-language-server", vim.fn.stdpath "data")
local sumneko_binary = string.format("%s/bin/%s/lua-language-server", sumneko_root_path, system_name)

local M = {}

M.config = luadev.setup {
  lspconfig = {
    cmd = { sumneko_binary, "-E", string.format("%s/main.lua", sumneko_root_path) },
    settings = {
      Lua = {
        completion = {
          showWord = "Disable",
          -- keywordSnippet = "Disable",
        },
        diagnostics = {
          enable = true,
          globals = { "dump", "profile", "reload" },
        },
      },
    },
  },
}

return M
