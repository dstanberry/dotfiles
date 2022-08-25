local M = {}

local prefs = {
  format = {
    convertTabsToSpaces = true,
    indentSize = 2,
    trimTrailingWhitespace = false,
    semicolons = "insert",
  },
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
  },
}

M.config = {
  settings = {
    javascript = prefs,
    typescript = prefs,
  },
}

return M
