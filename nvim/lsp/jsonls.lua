---@class remote.lsp.config
local M = {}

M.config = {
  before_init = function(_, new_config)
    new_config.settings.json.schemas =
      vim.tbl_deep_extend("force", new_config.settings.json.schemas or {}, require("schemastore").json.schemas())
  end,
  init_options = { provideFormatter = false },
  settings = {
    json = {
      validate = { enable = true },
    },
  },
}

return M
