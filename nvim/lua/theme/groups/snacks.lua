local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- |mini.align| `=<bs>fn==1<cr>t` 
  -- stylua: ignore
  return {
    SnacksNormal              = { fg = c.   white, bg = c.bg0 },

    SnacksNotifierTrace       = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderTrace = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconTrace   = { link = "DiagnosticHint" },
    SnacksNotifierTitleTrace  = { fg = ds.color.get_color "DiagnosticHint", bg = c.bg0 },

    SnacksNotifierDebug       = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderDebug = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconDebug   = { link = "DiagnosticHint" },
    SnacksNotifierTitleDebug  = { fg = ds.color.get_color "DiagnosticHint", bg = c.bg0 },

    SnacksNotifierInfo        = { fg   = c. white, bg = c.bg0 },
    SnacksNotifierBorderInfo  = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconInfo    = { link = "DiagnosticInfo" },
    SnacksNotifierTitleInfo   = { fg = ds.color.get_color "DiagnosticInfo", bg = c.bg0 },

    SnacksNotifierWarn        = { fg   = c. white, bg = c.bg0 },
    SnacksNotifierBorderWarn  = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconWarn    = { link = "DiagnosticWarn" },
    SnacksNotifierTitleWarn   = { fg = ds.color.get_color "DiagnosticWarn", bg = c.bg0 },

    SnacksNotifierError       = { fg   = c.white, bg = c.bg0 },
    SnacksNotifierBorderError = { fg   = c.bg0, bg   = c.bg0 },
    SnacksNotifierIconError   = { link = "DiagnosticError" },
    SnacksNotifierTitleError  = { fg = ds.color.get_color "DiagnosticError", bg = c.bg0 }
  }
end

return M
