local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    OctoBubble            = { link = "Normal" },
    OctoEditable          = { fg = c.white, bg = ds.color.darken(c.gray0, 10) },
    OctoFilePanelFilename = { link = "Normal" }
  }
end

return M
