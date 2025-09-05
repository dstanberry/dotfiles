---@class remote.lsp.config
local M = {}

M.config = {
  init_options = { provideFormatter = false },
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

return M
