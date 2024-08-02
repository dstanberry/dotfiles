local M = {}

---@param c util.theme_palette
---@return util.theme_hl
M.get = function(c)
  -- stylua: ignore
  return {
    -- package-info.nvim
    PackageInfoOutdatedVersion = { link = "DiagnosticVirtualTextWarn" },
    PackageInfoUpToDateVersion = { link = "DiagnosticVirtualTextInfo" }
  }
end

return M
