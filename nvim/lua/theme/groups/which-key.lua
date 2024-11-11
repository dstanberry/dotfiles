local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local BLUE_DARK = ds.color.blend(c.blue2, c.bg0, 0.08)
  -- stylua: ignore
  return {
    WhichKeyFloat     = { bg = BLUE_DARK },
    WhichKeyNormal    = { fg = c.white, bg = BLUE_DARK },
    WhichKeyBorder    = { fg = c.blue0, bg = BLUE_DARK },
    WhichKeyTitle     = { fg = c.blue0, bg = BLUE_DARK },
    WhichKeySeparator = { fg = ds.color.lighten(c.gray1, 20) },
    WhichKeyDesc      = { link = "Constant" },
    WhichKeyGroup     = { link = "Identifier" }
  }
end

return M
