-- verify schemastore is available
local ok, schemastore = pcall(require, "schemastore")
if not ok then
  return
end

local M = {}

M.config = {
  settings = {
    json = {
      schemas = schemastore.json.schemas {
        select = {
          ".eslintrc",
          "package.json",
          "tsconfig.json",
        },
      },
    },
  },
}

return M
