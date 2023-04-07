local M = {}

M.config = {
  before_init = function(_, config)
    local ok, Path = pcall(require, "plenary.path")
    if ok then
      local venv = Path:new((config.root_dir:gsub("/", Path.path.sep)), ".venv")
      if venv:joinpath("bin"):is_dir() then
        config.settings.python.pythonPath = tostring(venv:joinpath("bin", "python"))
      elseif has "win32" and venv:joinpath("Scripts"):is_dir() then
        config.settings.python.pythonPath = tostring(venv:joinpath("Scripts", "python.exe"))
      end
      require("remote.dap.debuggers.python").setup(config.settings.python.pythonPath)
    end
  end,
  settings = {
    python = {
      autoImportCompletions = true,
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      -- extraPaths = { "src", "/src" },
    },
  },
  on_init = require("remote.lsp.handlers").on_init {
    ["textDocument/completion"] = function(...)
      local err, result = ...
      if not err and result then
        local items = result.items or result
        items = require("util").map(function(acc, item)
          if
            not (item.data and item.data.funcParensDisabled)
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
