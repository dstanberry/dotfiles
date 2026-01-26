return {
  settings = {
    gopls = {
      analyses = {
        fillreturns = true,
        nilness = true,
        nonewvars = true,
        shadow = true,
        ST1003 = true,
        undeclaredname = true,
        unreachable = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      codelenses = {
        gc_details = true,
        generate = true,
        regenerate_cgo = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      buildFlags = { "-tags", "integration" },
      completeUnimported = true,
      diagnosticsDelay = "500ms",
      experimentalWatchedFileDelay = "200ms",
      gofumpt = false,
      matcher = "Fuzzy",
      staticcheck = true,
      symbolMatcher = "fuzzy",
      usePlaceholders = true,
    },
  },
  on_attach = function(client, _)
    if not client.server_capabilities.semanticTokensProvider then
      local semantic_tokens = client.config.capabilities.textDocument.semanticTokens
      if not semantic_tokens then return end
      client.server_capabilities.semanticTokensProvider = {
        full = true,
        legend = {
          tokenTypes = semantic_tokens.tokenTypes,
          tokenModifiers = semantic_tokens.tokenModifiers,
        },
        range = true,
      }
    end
  end,
}
