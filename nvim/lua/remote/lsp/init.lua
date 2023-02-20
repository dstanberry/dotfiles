-- verify lspconfig is available
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local handlers = reload "remote.lsp.handlers"
local util = require "util"

-- vim.lsp.set_log_level "trace"
-- vim.cmd.edit(vim.lsp.get_log_path())

local M = {}

M.setup = function()
  local servers = {
    angularls = {},
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
      local srv = (mod):match "[^%.]*$"
      local config = require(mod).config or {}
      if srv == "ls_emmet" then
        local configs = require "lspconfig.configs"
        if not configs.ls_emmet then
          configs.ls_emmet = { default_config = config }
        end
      elseif srv == "null-ls" then
        require(mod).setup(on_attach_nvim)
        do
          break
        end
      elseif srv == "powershell_es" and not has "win32" then
        do
          break
        end
      elseif srv == "rust_analyzer" then
        do
          break
        end
      elseif srv == "rust_tools" then
        require(mod).setup(vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config))
        do
          break
        end
      elseif srv == "lua_ls" then
        require(mod).setup()
      elseif srv == "tsserver" then
        require(mod).setup(vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config))
        do
          break
        end
      elseif srv == "zk" then
        require(mod).setup(vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config))
        do
          break
        end
      end
      servers = vim.tbl_deep_extend("force", servers, { [srv] = config })
    until true
  end

  for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend("force", {
      capabilities = client_capabilities,
      flags = { debounce_text_changes = 150 },
      on_attach = on_attach_nvim,
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
