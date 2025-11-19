local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    LuasnipChoiceNodePassive = { bold = true }
  }
end

return M
