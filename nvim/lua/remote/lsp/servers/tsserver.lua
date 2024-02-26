local handlers = require "remote.lsp.handlers"

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
  on_attach = function(client, bufnr)
    handlers.on_attach(client, bufnr)
    vim.keymap.set(
      "n",
      "gA",
      function()
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            only = {
              "source.addMissingImports.ts",
              "source.removeUnusedImports.ts",
              "source.organizeImports.ts",
              "source.sortImports.ts",
              "source.fixAll.tslint",
              "source.removeUnused.ts",
            },
            diagnostics = {},
          },
        }
      end,
      { buffer = bufnr, desc = "typescript: source actions" }
    )
  end,
}

return M
