-- verify lspconfig is available
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local handlers = reload "remote.lsp.handlers"
local util = require "util"

-- vim.lsp.set_log_level("debug")
-- vim.cmd.edit(vim.lsp.get_log_path())

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
      if key == "ls_emmet" then
        local configs = require "lspconfig.configs"
        if not configs.ls_emmet then
          configs.ls_emmet = { default_config = config }
        end
      elseif key == "null-ls" then
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
        require(mod).setup(false)
        extends[key] = { on_attach = require(mod).on_attach }
      elseif key == "tsserver" then
        local has_ts, typescript = pcall(require, "typescript")
        if has_ts then
          typescript.setup {
            disable_commands = false,
            debug = false,
            go_to_source_definition = {
              fallback = true,
            },
            server = {
              vim.tbl_deep_extend("force", {
                capabilities = client_capabilities,
                flags = { debounce_text_changes = 150 },
                on_attach = on_attach_nvim,
              }, config),
            },
          }
          do
            break
          end
        end
      elseif key == "zk" then
        require(mod).setup(vim.tbl_deep_extend("force", {
          capabilities = client_capabilities,
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach_nvim,
        }, config))
        do
          break
        end
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
