local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    DiffviewFilePanelTitle   = { link = "@markup.environment" },
    DiffviewFilePanelCounter = { link = "Normal" },
    DiffviewHash             = { link = "Boolean" },
  }
end

return M
