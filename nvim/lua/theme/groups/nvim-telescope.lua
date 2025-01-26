local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local GRAY = ds.color.darken(c.gray0, 10)
  local GRAY_DARK = ds.color.darken(c.gray0, 25)
  local BLUE = ds.color.darken(c.blue1, 43)
  -- stylua: ignore
  return {
    TelescopePreviewBorder = { fg = c.bg0, bg = c.bg0 },
    TelescopePreviewNormal = { fg = c.green2, bg = c.bg0 },
    TelescopePreviewTitle = { fg = c.bg0 },

    TelescopePromptBorder = { fg = GRAY, bg = GRAY },
    TelescopePromptCounter = { fg = c.gray1 },
    TelescopePromptNormal = { bg = GRAY },
    TelescopePromptPrefix = { fg = c.green2 },
    TelescopePromptTitle = { fg = c.bg2, bg = c.red1, bold = true },

    TelescopeResultsBorder = { fg = GRAY_DARK, bg = GRAY_DARK },
    TelescopeResultsNormal = { bg = GRAY_DARK },
    TelescopeResultsTitle = { fg = GRAY_DARK },

    TelescopeMatching = { fg = c.orange0, bold = true },
    TelescopeMultiSelection = { fg = c.magenta1 },
    TelescopeSelection = { bg = BLUE, bold = true },
    TelescopeSelectionCaret = { fg = c.fg0, bg = BLUE, bold = true }
  }
end

return M
