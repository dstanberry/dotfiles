local M = {}

M.config = {
  settings = {
    Lua = {
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
        showWord = "Disable",
        -- keywordSnippet = "Disable",
      },
      diagnostics = {
        enable = true,
        disable = { "cast-local-type", "missing-parameter", "param-type-mismatch" },
        globals = { "ds" },
      },
      format = {
        enable = false,
      },
      hint = {
        enable = true,
        paramType = true,
        setType = false,
        arrayIndex = "Disable",
        paramName = "Disable",
        semicolon = "Disable",
      },
      workspace = {
        checkThirdParty = false,
        library = {},
      },
    },
  },
}

return M
