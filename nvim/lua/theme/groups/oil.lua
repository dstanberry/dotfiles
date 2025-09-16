local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    OilFloatTitle = { fg = c.red3, bg = c.bg0 },
  }
end

return M
