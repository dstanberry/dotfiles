---@class remote.lsp.config
local M = {}

M.config = {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "warn",
    },
  },
  on_attach = function(client, bufnr)
    local handlers = require "remote.lsp.handlers"

    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentFormattingProvider = false
    handlers.on_attach(client, bufnr)

    vim.keymap.set("n", "<leader>l", "", { buffer = bufnr, desc = "+lsp (ruff)" })

    local _organize = handlers.run_code_action["source.organizeImports"]
    vim.keymap.set("n", "<leader>lo", _organize, { buffer = bufnr, desc = "typescript: organize imports" })
  end,
}

return M
