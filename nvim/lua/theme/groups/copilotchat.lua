local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local BG_BLUE = ds.color.lighten(ds.color.blend(c.diff_text, c.bg0, 0.9), 9)
  local FG_BLUE = ds.color.lighten(c.blue4, 0.11)

  -- stylua: ignore
  return {
    CopilotChatAnnotation = { link = "@comment.documentation" },
    CopilotChatHeader     = { link = "htmlH1" },
    CopilotChatHelp       = { link = "@comment" },
    CopilotChatSelection  = { link = "Visual" },
    CopilotChatSeparator  = { fg = c.overlay0 },
    CopilotChatStatus     = { fg = c.green2 },
    CopilotChatUri        = { link = "@conceal" },

    CopilotChatPrompt     = { fg = FG_BLUE, bg = BG_BLUE },
    CopilotChatModel      = { fg = FG_BLUE, bg = BG_BLUE },
    CopilotChatResource   = { fg = FG_BLUE, bg = BG_BLUE },
    CopilotChatTool       = { fg = FG_BLUE, bg = BG_BLUE },
  }
end

return M
