local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    LazyButton       = { fg = c.white, bg = c.bg3 },
    LazyButtonActive = { bg = ds.color.get_color("Visual", true), bold = true }
  }
end

return M
