-- verify schemastore is available
local ok, schemastore = pcall(require, "schemastore")
if not ok then return end

local M = {}

M.config = {
  init_options = { provideFormatter = false },
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
    },
  },
}

return M
