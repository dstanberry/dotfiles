---@class remote.lsp.config
local M = {}

M.config = {
  settings = {
    Lua = {
      codeLens = { enable = true },
      completion = {
        callSnippet = "Replace",
        showWord = "Disable",
      },
      diagnostics = {
        enable = true,
        disable = { "cast-local-type", "missing-parameter", "param-type-mismatch" },
        globals = { "ds", "vim" },
      },
      doc = { privateName = { "^_" } },
      format = { enable = false },
      hint = {
        enable = true,
        paramType = true,
        setType = false,
        arrayIndex = "Disable",
        paramName = "Disable",
        semicolon = "Disable",
      },
      hover = { expandAlias = false },
      type = {
        castNumberToInteger = true,
        inferParamType = true,
      },
      unusedLocalExclude = { "_*" },
      workspace = {
        checkThirdParty = false,
        library = {},
      },
    },
  },
}

return function() return M end
