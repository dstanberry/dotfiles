local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    PanelHeading = { link = "Title" }
  }
end

return M
