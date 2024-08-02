local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  local GRAY = ds.color.darken(c.gray0, 10)
  local GRAY_DARK = ds.color.darken(c.gray0, 25)
  local BLUE = ds.color.darken(c.blue1, 43)
  -- stylua: ignore
  return {
    TelescopePromptBorder = { fg = GRAY, bg = GRAY },
    TelescopePreviewBorder = { fg = c.bg0, bg = c.bg0 },
    TelescopeResultsBorder = { fg = GRAY_DARK, bg = GRAY_DARK },

    TelescopePromptTitle = { fg = c.bg2, bg = c.red1, bold = true },
    TelescopePreviewTitle = { fg = c.bg0 },
    TelescopeResultsTitle = { fg = GRAY_DARK },

    TelescopePromptCounter = { fg = c.gray1 },
    TelescopePromptPrefix = { fg = c.green2 },
    TelescopePromptNormal = { bg = GRAY },
    TelescopePreviewNormal = { fg = c.green2, bg = c.bg0 },
    TelescopeResultsNormal = { bg = GRAY_DARK },
    TelescopeMatching = { fg = c.orange0, bold = true },
    TelescopeMultiSelection = { fg = c.magenta1 },
    TelescopeSelection = { bg = BLUE, bold = true },
    TelescopeSelectionCaret = { fg = c.fg0, bg = BLUE, bold = true }
  }
end

return M
