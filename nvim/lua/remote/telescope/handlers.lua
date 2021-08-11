---------------------------------------------------------------
-- => Telescope Function Handlers
---------------------------------------------------------------
-- verify telescope is available
if not pcall(require, "telescope") then
  return
end

-- lsp handlers
vim.lsp.handlers["callHierarchy/incomingCalls"] = require("remote.telescope").lsp_dynamic_workspace_symbols
vim.lsp.handlers["callHierarchy/outgoingCalls"] = require("remote.telescope").lsp_dynamic_workspace_symbols
vim.lsp.handlers["textDocument/codeAction"] = require("remote.telescope").lsp_code_actions
vim.lsp.handlers["textDocument/declaration"] = require("remote.telescope").lsp_definitions
vim.lsp.handlers["textDocument/definition"] = require("remote.telescope").lsp_definitions
vim.lsp.handlers["textDocument/documentSymbol"] = require("remote.telescope").lsp_document_symbols
vim.lsp.handlers["textDocument/implementation"] = require("remote.telescope").lsp_implementations
vim.lsp.handlers["textDocument/references"] = require("remote.telescope").lsp_references
vim.lsp.handlers["textDocument/typeDefinition"] = require("remote.telescope").lsp_definitions
vim.lsp.handlers["workspace/symbol"] = require("remote.telescope").lsp_workspace_symbols
