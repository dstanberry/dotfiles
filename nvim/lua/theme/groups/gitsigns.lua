local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    GitSignsAdd              = { fg = c.green2 },
    GitSignsChange           = { fg = c.yellow2 },
    GitSignsDelete           = { fg = c.red1 },
    GitSignsChangeDelete     = { fg = c.orange0 },
    GitSignsCurrentLineBlame = { fg = c.gray1, italic = true },

    GitSignsAddInline        = { link = "DiffAdded" },
    GitSignsChangeInline     = { link = "DiffChange" },
    GitSignsDeleteInline     = { link = "DiffRemoved" },
  }
end

return M
