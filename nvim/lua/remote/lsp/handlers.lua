vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  signs = true,
  virtual_text = { prefix = "▪", spacing = 4 },
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

local has_tele, telescope = pcall(require, "remote.telescope")
if has_tele then
  vim.lsp.handlers["textDocument/codeAction"] = telescope.lsp_code_actions
  vim.lsp.handlers["textDocument/declaration"] = telescope.lsp_definitions
  vim.lsp.handlers["textDocument/definition"] = telescope.lsp_definitions
  vim.lsp.handlers["textDocument/documentSymbol"] = telescope.lsp_document_symbols
  vim.lsp.handlers["textDocument/implementation"] = telescope.lsp_implementations
  vim.lsp.handlers["textDocument/references"] = telescope.lsp_references
  vim.lsp.handlers["textDocument/typeDefinition"] = telescope.lsp_definitions
  vim.lsp.handlers["workspace/symbol"] = telescope.lsp_workspace_symbols
end
