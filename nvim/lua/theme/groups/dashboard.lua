local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    DashboardHeader   = { fg = c.blue4 },
    DashboardFooter   = { fg = c.blue0 },

    -- Doom theme
    DashboardDesc     = { fg = c.overlay1 },
    DashboardKey      = { fg = c.rose0 },
    DashboardIcon     = { fg = c.overlay1, bold = true },
    DashboardShortCut = { fg = c.overlay1 },
  }
end

return M
