local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    LuasnipChoiceNodePassive = { bold = true }
  }
end

return M
