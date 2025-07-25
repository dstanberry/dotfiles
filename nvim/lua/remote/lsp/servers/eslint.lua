---@class remote.lsp.config
local M = {}

M.config = {
  settings = {
    workingDirectories = { mode = "auto" },
  },
  on_attach = function(client, bufnr)
    local handlers = require "remote.lsp.handlers"

    handlers.on_attach(client, bufnr)
    ds.format.register(handlers.formatter { name = "eslint: lsp", primary = false, priority = 200, filter = "eslint" })
  end,
}

return M
