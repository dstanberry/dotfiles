local M = {}

M.config = {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  on_init = require("remote.lsp.handlers").on_init {
    ["textDocument/completion"] = function(...)
      local err, result = ...
      if not err and result then
        local items = result.items or result
        items = require("util").map(function(acc, item)
          if
            (item.data and item.data.funcParensDisabled)
            and (
              item.kind == vim.lsp.protocol.CompletionItemKind.Constructor
              or item.kind == vim.lsp.protocol.CompletionItemKind.Function
              or item.kind == vim.lsp.protocol.CompletionItemKind.Method
            )
          then
            item.insertText = item.label .. "($1)$0"
            item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet
          end
          table.insert(acc, item)
          return acc
        end, items)
      end
    end,
  },
}

return M
