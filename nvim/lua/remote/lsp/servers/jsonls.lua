-- verify schemastore is available
local ok, schemastore = pcall(require, "schemastore")
if not ok then return end

local M = {}

M.config = {
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
    },
  },
}

return M
