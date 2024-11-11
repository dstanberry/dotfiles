local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  -- stylua: ignore
  return {
    -- package-info.nvim
    PackageInfoOutdatedVersion = { link = "DiagnosticVirtualTextWarn" },
    PackageInfoUpToDateVersion = { link = "DiagnosticVirtualTextInfo" }
  }
end

return M
