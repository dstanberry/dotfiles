-- verify lua-dev is available
local ok, luadev = pcall(require, "lua-dev")
if not ok then
  return
end

local fname
local system_name
if vim.fn.has "mac" == 1 then
  system_name = "macOS"
  fname = "lua-language-server"
elseif vim.fn.has "unix" == 1 then
  system_name = "Linux"
  fname = "lua-language-server"
elseif vim.fn.has "win32" == 1 then
  system_name = "Windows"
  fname = "lua-language-server.exe"
else
  print "Unsupported system for sumneko"
  return
end

local sumneko_root_path = string.format("%s/lspconfig/lua-language-server", vim.fn.stdpath "data")
local sumneko_binary = string.format("%s/bin/%s/%s", sumneko_root_path, system_name, fname)

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
