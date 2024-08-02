local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
      OctoBubble   = { link = "Normal" },
      OctoEditable = { fg = c.white, bg = ds.color.darken(c.gray0, 10) }
  }
end

return M
