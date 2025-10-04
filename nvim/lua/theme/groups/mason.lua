local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    MasonMutedBlock         = { fg = c.white, bg = c.bg3 },
    MasonHighlightBlockBold = { bg = ds.color.get("Visual", true), bold = true }
  }
end

return M
