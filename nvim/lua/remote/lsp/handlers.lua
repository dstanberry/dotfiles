vim.diagnostic.config {
  severity_sort = true,
  signs = true,
  underline = false,
  update_in_insert = false,
  float = {
    -- border = "rounded",
    focusable = false,
    show_header = true,
    source = "always",
  },
  virtual_text = {
    prefix = "▪",
    source = "if_many",
    spacing = 8,
  },
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = string.format("DiagnosticSign%s", type)
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

local has_tele, telescope = pcall(require, "remote.telescope")
if has_tele then
  -- vim.lsp.handlers["textDocument/codeAction"] = telescope.lsp_code_actions
  vim.lsp.handlers["textDocument/declaration"] = telescope.lsp_definitions
  vim.lsp.handlers["textDocument/definition"] = telescope.lsp_definitions
  vim.lsp.handlers["textDocument/documentSymbol"] = telescope.lsp_document_symbols
  vim.lsp.handlers["textDocument/implementation"] = telescope.lsp_implementations
  vim.lsp.handlers["textDocument/references"] = telescope.lsp_references
  vim.lsp.handlers["textDocument/typeDefinition"] = telescope.lsp_definitions
  vim.lsp.handlers["workspace/symbol"] = telescope.lsp_workspace_symbols
end
