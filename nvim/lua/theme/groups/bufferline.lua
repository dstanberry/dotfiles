local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    PanelHeading = { link = "Title" }
  }
end

return M
