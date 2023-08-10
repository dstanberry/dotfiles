-- verify schemastore is available
local ok, schemastore = pcall(require, "schemastore")
if not ok then return end

local M = {}

M.config = {
  settings = {
    yaml = {
      schemas = schemastore.yaml.schemas(),
    },
  },
}

return M
