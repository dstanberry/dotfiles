local M = {}

local preferences = {
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
    includeInlayParameterNameHints = true,
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
  },
}

M.config = {
  settings = {
    javascript = preferences,
    typescript = preferences,
  },
}

return M
