---@class remote.lsp.config
local M = {}

M.config = {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "warn",
    },
  },
  on_attach = function(_, bufnr)
    local handlers = require "remote.lsp.handlers"
    local _organize = handlers.run_code_action["source.organizeImports"]

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

M.server_capabilities = {
  hoverProvider = false,
  documentFormattingProvider = false,
}

return M
