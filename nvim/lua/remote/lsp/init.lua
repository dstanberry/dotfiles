-- verify lspconfig is available
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local handlers = reload "remote.lsp.handlers"
local util = require "util"

-- vim.lsp.set_log_level("debug")
-- vim.cmd('e '..vim.lsp.get_log_path())

local M = {}

M.setup = function()
  local extends = {}
  local servers = {
    bashls = {},
    cmake = {},
    cssls = {},
    html = {},
  }

  local on_attach_nvim = handlers.on_attach
  local client_capabilities = handlers.get_client_capabilities()

  local configurations = vim.api.nvim_get_runtime_file("lua/remote/lsp/servers/*.lua", true)
  for _, file in ipairs(configurations) do
    repeat
      local mod = util.get_module_name(file)
      local key = (mod):match "[^%.]*$"
      local config = require(mod).config or {}
      if key == "null-ls" then
        require(mod).setup(on_attach_nvim)
        do
          break
        end
      elseif key == "rust_analyzer" then
        do
          break
        end
      elseif key == "rust_tools" then
        require(mod).setup(vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config))
        do
          break
        end
      elseif key == "sumneko_lua" then
        extends[key] = { on_attach = require(mod).on_attach }
      elseif key == "zk" then
        local configs = require "lspconfig.configs"
        configs.zk = { default_config = config }
        configs.zk.index = require(mod).index
        configs.zk.new = require(mod).new
        extends[key] = { on_attach = require(mod).on_attach }
      end
      servers = vim.tbl_deep_extend("force", servers, { [key] = config })
    until true
  end

  for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend("force", {
      capabilities = client_capabilities,
      flags = { debounce_text_changes = 150 },
      on_attach = extends[server] and extends[server].on_attach or on_attach_nvim,
    }, config))
  end
end

return setmetatable({}, {
  __index = function(t, k)
    if M[k] then
      return M[k]
    else
      local valid, val = pcall(require, string.format("remote.lsp.%s", k))
      if valid then
        rawset(t, k, val)
        return val
      end
    end
  end,
})
