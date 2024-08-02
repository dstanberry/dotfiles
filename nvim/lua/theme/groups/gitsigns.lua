local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    GitSignsAdd              = { fg = c.green2 },
    GitSignsChange           = { fg = c.yellow2 },
    GitSignsDelete           = { fg = c.red1 },
    GitSignsChangeDelete     = { fg = c.orange0 },
    GitSignsCurrentLineBlame = { fg = c.gray1, italic = true }
  }
end

return M
