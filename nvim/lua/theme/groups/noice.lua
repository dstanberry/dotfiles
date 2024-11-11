local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    -- noice.nvim
    NoiceFormatProgressTodo = { bg = ds.color.blend(c.blue1, c.grayX, 0.20) },
    NoiceFormatProgressDone = { bg = c.blue0 },
    NoiceFormatEvent        = { link = "Comment" },
    NoiceFormatKind         = { link = "Comment" },

    NoiceSymbolNormal       = { link = "WinbarContext" },
    NoiceSymbolSeparator    = { fg = ds.color.blend(c.purple1, c.bg2, 0.38) }
  }
end

return M
