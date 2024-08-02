local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    MasonMutedBlock         = { fg = c.white, bg = c.bg3 },
    MasonHighlightBlockBold = { bg = ds.color.get_color("Visual", true), bold = true }
  }
end

return M
