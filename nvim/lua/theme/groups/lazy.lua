local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    LazyButton       = { fg = c.white, bg = c.bg3 },
    LazyButtonActive = { fg = c.grayX, bg = ds.color.blend(c.blue4, ds.color.get("Visual", true), 0.8), bold = true }
  }
end

return M
