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
    local _organize = handlers.run_code_action["source.organizeImports"]

    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentFormattingProvider = false

    handlers.on_attach(client, bufnr)

    ds.format.register(handlers.formatter {
      name = "ruff: organizeImports",
      primary = false,
      priority = 200,
      filter = "ruff",
      format = _organize,
    })

    vim.keymap.set("n", "<leader>l", "", { buffer = bufnr, desc = "+lsp (python)" })
    vim.keymap.set("n", "<leader>lo", _organize, { buffer = bufnr, desc = "python: organize imports" })
  end,
}

return M
