local M = {}

---@param c util.theme.palette
---@return util.theme.hl
function M.get(c)
  -- stylua: ignore
  return {
    CodeCompanionChatInfoBanner  = { fg = c.overlay1, bg = c.bg0 },
    CodeCompanionInlineDiffHint  = { fg = c.overlay1, bg = c.bg0 },

    -- custom
    CodeCompanionInlineDiffTitle = { fg = c.blue0, bg = c.bg0, bold = true },
  }
end

return M
