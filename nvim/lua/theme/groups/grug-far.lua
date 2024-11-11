local M = {}

---@param c util.theme.palette
---@return util.theme.hl
M.get = function(c)
  local GREEN = ds.color.blend(c.green1, c.bg2, 0.66)
  -- stylua: ignore
  return {
    GrugFarInputLabel             = { link = "DiagnosticInfo" },
    GrugFarInputPlaceholder       = { link = "LspCodeLens" },
    GrugFarResultsHeader          = { link = "DiagnosticUnnecessary" },
    GrugFarResultsStats           = { link = "DiagnosticUnnecessary" },
    GrugFarResultsLineColumn      = { link = "LineNr" },
    GrugFarResultsLineNo          = { link = "LineNr" },
    GrugFarResultsMatch           = { fg = c.bgX, bg = GREEN, bold = true },
    GrugFarResultsPath            = { fg = c.gray2, italic = true },
    GrugFarResultsChangeIndicator = { fg = c.green0 }
  }
end

return M
