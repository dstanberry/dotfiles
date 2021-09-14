---------------------------------------------------------------
-- => LSP Handlers
---------------------------------------------------------------
if vim.lsp.setup then
  vim.lsp.setup {
    floating_preview = {
      border = "single",
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
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = " ",
        Keyword = " ",
        Method = " ",
        Module = "{} ",
        Operator = " ",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
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
