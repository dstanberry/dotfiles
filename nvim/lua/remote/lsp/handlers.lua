-- verify lspconfig is available
local ok, _ = pcall(require, "lspconfig")
if not ok then
  return
end

local M = {}

M.on_attach = function(client, bufnr)
  if client.server_capabilities.declarationProvider then
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
  end

  if client.server_capabilities.codeActionProvider then
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr })
  end

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_augroup("lsp_codelens", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = "lsp_codelens",
      once = true,
      pattern = "<buffer>",
      callback = require("vim.lsp.codelens").refresh,
    })

    vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold" }, {
      group = "lsp_codelens",
      pattern = "<buffer>",
      callback = require("vim.lsp.codelens").refresh,
    })

    vim.keymap.set("n", "gll", vim.lsp.codelens.display, { buffer = bufnr })
    vim.keymap.set("n", "glr", vim.lsp.codelens.run, { buffer = bufnr })
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_highlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = "lsp_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.server_capabilities.signatureHelpProvider then
    vim.api.nvim_create_augroup("lsp_signature", { clear = true })

    vim.api.nvim_create_autocmd("CursorHoldI", {
      group = "lsp_signature",
      pattern = "<buffer>",
      callback = vim.lsp.buf.signature_help,
    })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "ff", function()
      vim.lsp.buf.format { async = true }
    end, { buffer = bufnr })
  end

  local list_workspace_folders = function()
    dump(vim.lsp.buf.list_workspace_folders())
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr })
  vim.keymap.set("n", "gk", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
  vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, { buffer = bufnr })
  vim.keymap.set("n", "g/", vim.lsp.buf.rename, { buffer = bufnr })
  vim.keymap.set("n", "g.", vim.diagnostic.open_float, { buffer = bufnr })
  vim.keymap.set("n", "gn", vim.diagnostic.goto_next, { buffer = bufnr })
  vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, { buffer = bufnr })
  vim.keymap.set("n", "<localleader>wl", list_workspace_folders, { buffer = bufnr })
  vim.keymap.set("n", "<localleader>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr })
  vim.keymap.set("n", "<localleader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr })
end

M.get_client_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = cmp.update_capabilities(capabilities)
  end
  return capabilities
end

M.setup = function()
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
    vim.lsp.handlers["textDocument/documentSymbol"] = telescope.lsp_symbols
    vim.lsp.handlers["textDocument/implementation"] = telescope.lsp_implementations
    vim.lsp.handlers["textDocument/references"] = telescope.lsp_references
    vim.lsp.handlers["textDocument/typeDefinition"] = telescope.lsp_definitions
    vim.lsp.handlers["workspace/symbol"] = telescope.lsp_workspace_symbols
  end
end

return M
