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

vim.api.nvim_create_augroup("lsp_tssserver", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = "lsp_tssserver",
  callback = function(args)
    if not (args.data and args.data.client_id) then
      return
    end

    local bufnr = args.buf
    vim.keymap.set("n", "ff", function()
      typescript.actions.organizeImports()
      vim.lsp.buf.format { async = true }
    end, { buffer = bufnr, desc = "typescript: lsp format document" })
  end,
})

return M
