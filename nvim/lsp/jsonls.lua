---@class remote.lsp.config
local M = {}

M.config = {
  init_options = { provideFormatter = false },
  on_new_config = function(new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      validate = { enable = true },
    },
  },
}

return M
