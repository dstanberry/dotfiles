-- verify lua-dev is available
local ok, luadev = pcall(require, "lua-dev")
if not ok then
  return
end

local util = require "util"

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

local basedir = string.format("%s/lspconfig", vim.fn.stdpath "data")
local root_path = string.format("%s/lua-language-server", basedir)
local executable = string.format("%s/bin/%s/%s", root_path, system_name, fname)

local M = {}

M.setup = function(force)
  local install_cmd = [[
    git clone https://github.com/sumneko/lua-language-server
    cd lua-language-server
    git submodule update --init --recursive
    cd 3rd/luamake
    ./compile/install.sh
    cd ../..
    ./3rd/luamake/luamake rebuild
  ]]
  util.terminal.install_package("lua-language-server", basedir, basedir, install_cmd, force)
end

M.config = luadev.setup {
  lspconfig = {
    cmd = { executable, "-E", string.format("%s/main.lua", root_path) },
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
