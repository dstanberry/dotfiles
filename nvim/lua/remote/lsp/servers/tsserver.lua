local M = {}

local ts_settings = {
  implementationsCodeLens = {
    enabled = true,
  },
  referencesCodeLens = {
    enabled = true,
    showOnAllFunctions = true,
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
    completions = {
      completeFunctionCalls = true,
    },
    javascript = ts_settings,
    typescript = ts_settings,
    javascriptreact = ts_settings,
    typescriptreact = ts_settings,
    ["javascript.jsx"] = ts_settings,
    ["typescript.tsx"] = ts_settings,
  },
}

return M
