local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    LuasnipChoiceNodePassive = { bold = true }
  }
end

return M
