local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
   CodeCompanionChatInfoBanner  = { fg = c.fg_comment },
   CodeCompanionInlineDiffHint  = { fg = c.fg_comment },
  }
end

return M
