---@class remote.lsp.config
local M = {}

M.config = {
  settings = {
    workingDirectories = { mode = "auto" },
  },
  on_attach = function(_, bufnr)
    local handlers = require "remote.lsp.handlers"

    ds.format.register(handlers.formatter { name = "eslint: lsp", primary = false, priority = 200, filter = "eslint" })
  end,
}

M.server_capabilities = {
  hoverProvider = false,
}

return function() return M end
