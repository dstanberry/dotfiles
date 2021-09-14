---------------------------------------------------------------
-- => LSP Handlers
---------------------------------------------------------------
if vim.lsp.setup then
  vim.lsp.setup {
    floating_preview = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    diagnostics = {
      signs = { error = " ", warning = " ", hint = " ", information = " " },
      display = {
        underline = false,
        update_in_insert = false,
        severity_sort = true,
        signs = true,
        virtual_text = { prefix = "▪", spacing = 4 },
      },
    },
    completion = {
      kind = {
        Class = "פּ ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = "了 ",
        EnumMember = "  ",
        Event = " ",
        Field = "陋 ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = "﯅ ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Operator = " ",
        Property = "襁 ",
        Reference = " ",
        Snippet = "賂 ",
        Struct = " ",
        Text = " ",
        TypeParameter = "т ",
        Unit = " ",
        Value = " ",
        Variable = "勞 ",
      },
    },
  }
else
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

  local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
  for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

if pcall(require, "telescope") then
  vim.lsp.handlers["textDocument/codeAction"] = require("remote.telescope").lsp_code_actions
  vim.lsp.handlers["textDocument/declaration"] = require("remote.telescope").lsp_definitions
  vim.lsp.handlers["textDocument/definition"] = require("remote.telescope").lsp_definitions
  vim.lsp.handlers["textDocument/documentSymbol"] = require("remote.telescope").lsp_document_symbols
  vim.lsp.handlers["textDocument/implementation"] = require("remote.telescope").lsp_implementations
  vim.lsp.handlers["textDocument/references"] = require("remote.telescope").lsp_references
  vim.lsp.handlers["textDocument/typeDefinition"] = require("remote.telescope").lsp_definitions
  vim.lsp.handlers["workspace/symbol"] = require("remote.telescope").lsp_workspace_symbols
end
