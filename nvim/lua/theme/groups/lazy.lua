local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    LazyButton       = { fg = c.white, bg = c.bg3 },
    LazyButtonActive = { bg = ds.color.get("Visual", true), bold = true }
  }
end

return M
