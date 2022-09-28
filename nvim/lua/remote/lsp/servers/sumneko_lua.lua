-- verify lua-dev is available
local ok, luadev = pcall(require, "lua-dev")
if not ok then
  return
end

local util = require "util"

local fname
if has "mac" then
  fname = "lua-language-server"
elseif has "unix" then
  fname = "lua-language-server"
elseif has "win32" then
  fname = "lua-language-server.exe"
else
  print "Unsupported system for sumneko"
  return
end

local path = string.format("%s/lspconfig", vim.fn.stdpath "data")
local basedir = string.format("%s/lua-language-server", path)
local executable = string.format("%s/bin/%s", basedir, fname)

local M = {}

M.on_attach = function(client, bufnr)
  client.server_capabilities.documentHighlightProvider = false
  require("remote.lsp").handlers.on_attach(client, bufnr)
end

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
  util.terminal.install_package("lua-language-server", basedir, path, install_cmd, force)
  luadev.setup {
    library = {
      enabled = true,
      runtime = true,
      types = true,
      plugins = true,
    },
    -- setup_jsonls = true,
    -- override = function(root_dir, options) end,
  }
end

M.config = {
  cmd = { executable },
  settings = {
    Lua = {
      completion = {
        showWord = "Disable",
        -- keywordSnippet = "Disable",
      },
      diagnostics = {
        enable = true,
        disable = { "cast-local-type", "missing-parameter", "param-type-mismatch" },
        globals = { "dump", "has", "profile", "reload" },
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}

return M
