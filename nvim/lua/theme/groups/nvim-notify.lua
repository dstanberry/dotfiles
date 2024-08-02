local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    NotifyTRACEBody   = { fg = c.white, bg = c.bg0 },
    NotifyTRACEBorder = { fg = c.bg0, bg = c.bg0 },
    NotifyTRACEIcon   = { link = "Debug" },
    NotifyTRACETitle  = { link = "Debug" },

    NotifyDEBUGBody   = { fg = c.white, bg = c.bg0 },
    NotifyDEBUGBorder = { fg = c.bg0, bg = c.bg0 },
    NotifyDEBUGIcon   = { link = "Debug" },
    NotifyDEBUGTitle  = { link = "Debug" },

    NotifyINFOBody    = { fg = c.white, bg = c.bg0 },
    NotifyINFOBorder  = { fg = c.bg0, bg = c.bg0 },
    NotifyINFOIcon    = { link = "String" },
    NotifyINFOTitle   = { link = "String" },

    NotifyWARNBody    = { fg = c.white, bg = c.bg0 },
    NotifyWARNBorder  = { fg = c.bg0, bg = c.bg0 },
    NotifyWARNIcon    = { link = "WarningMsg" },
    NotifyWARNTitle   = { link = "WarningMsg" },

    NotifyERRORBody   = { fg = c.white, bg = c.bg0 },
    NotifyERRORBorder = { fg = c.bg0, bg = c.bg0 },
    NotifyERRORIcon   = { link = "ErrorMsg" },
    NotifyERRORTitle  = { link = "ErrorMsg" }
  }
end

return M
