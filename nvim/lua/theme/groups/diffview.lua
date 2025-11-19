local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    DiffviewFilePanelTitle   = { link = "@markup.environment" },
    DiffviewFilePanelCounter = { link = "Normal" },
    DiffviewHash             = { link = "Boolean" },
  }
end

return M
