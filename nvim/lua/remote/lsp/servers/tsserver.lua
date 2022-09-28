-- verify typescript is available
local ok, typescript = pcall(require, "typescript")
if not ok then
  return
end

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

M.setup = function(config)
  typescript.setup {
    disable_commands = false,
    debug = false,
    go_to_source_definition = {
      fallback = true,
    },
    server = { config },
  }
end

M.config = {
  settings = {
    javascript = prefs,
    typescript = prefs,
  },
}

return M
