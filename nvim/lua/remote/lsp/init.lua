---------------------------------------------------------------
-- => Language Server Protocol Configuration
---------------------------------------------------------------
-- verify lspconfig and nlua-nvim are available
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

-- enable debugging
-- vim.lsp.set_log_level("debug")
-- vim.cmd('e'..vim.lsp.get_log_path())

-- define buffer local features
local on_attach_nvim = function(client, bufnr)
  local nnoremap = vim.keymap.nnoremap
  local vnoremap = vim.keymap.vnoremap
  -- define symbol highlighting when supported by server
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
      false
    )
  end
  -- define keybinds for code actions / diagnostics
  nnoremap { "ga", vim.lsp.buf.code_action, buffer = bufnr }
  nnoremap { "gD", vim.lsp.buf.declaration, buffer = bufnr }
  nnoremap { "gd", vim.lsp.buf.definition, buffer = bufnr }
  nnoremap { "gt", vim.lsp.buf.type_definition, buffer = bufnr }
  nnoremap { "gk", vim.lsp.buf.hover, buffer = bufnr }
  nnoremap { "gi", vim.lsp.buf.implementation, buffer = bufnr }
  nnoremap { "gh", vim.lsp.buf.signature_help, buffer = bufnr }
  nnoremap { "gr", vim.lsp.buf.references, buffer = bufnr }
  nnoremap { "gs", vim.lsp.buf.document_symbol, buffer = bufnr }
  nnoremap { "g/", vim.lsp.buf.rename, buffer = bufnr }
  -- stylua: ignore
  nnoremap { "g.", function() vim.lsp.diagnostic.show_line_diagnostics { border = "single" } end, buffer = bufnr, }
  -- stylua: ignore
  nnoremap { "gn", function() vim.lsp.diagnostic.goto_next { popup_opts = { border = "single" } } end, buffer = bufnr, }
  -- stylua: ignore
  nnoremap { "gp", function() vim.lsp.diagnostic.goto_prev { popup_opts = { border = "single" } } end, buffer = bufnr, }
  -- stylua: ignore
  nnoremap { "gl", vim.lsp.diagnostic.set_loclist }
  -- stylua: ignore
  nnoremap { "<localleader>wl", function() P(vim.lsp.buf.list_workspace_folders()) end, buffer = bufnr, }
  nnoremap { "<localleader>wa", vim.lsp.buf.add_workspace_folder, buffer = bufnr }
  nnoremap { "<localleader>wr", vim.lsp.buf.remove_workspace_folder, buffer = bufnr }
  -- define keybind for document formatting when supported by server
  if client.resolved_capabilities.document_formatting then
    nnoremap { "ff", vim.lsp.buf.formatting, buffer = bufnr }
  end
  if client.resolved_capabilities.document_range_formatting then
    vnoremap { "ff", vim.lsp.buf.range_formatting, buffer = bufnr }
  end
  -- configure lsp_signature.nvim
  local has_sig, lspsignature = pcall(require, "lsp_signature")
  if not has_sig then
    return
  end
  lspsignature.on_attach {
    bind = true,
    doc_lines = 2,
    floating_window = true,
    fix_pos = false,
    hint_enable = false,
    handler_opts = {
      border = "none",
    },
  }
end

-- diagnostic symbols and highlight groups
vim.fn.sign_define("LspDiagnosticsSignError", {
  text = " ",
  texthl = "LspDiagnosticsSignError",
})
vim.fn.sign_define("LspDiagnosticsSignWarning", {
  text = " ",
  texthl = "LspDiagnosticsSignWarning",
})
vim.fn.sign_define("LspDiagnosticsSignInformation", {
  text = " ",
  texthl = "LspDiagnosticsSignInformation",
})
vim.fn.sign_define("LspDiagnosticsSignHint", {
  text = " ",
  texthl = "LspDiagnosticsSignHint",
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  signs = true,
  update_in_insert = false,
  virtual_text = { prefix = "▪", spacing = 4 },
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

-- pack lsp configuration
local function get_server_configuration()
  -- enable snippet support
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  return { capabilities = capabilities, on_attach = on_attach_nvim }
end

-- load defined servers
local function load_servers()
  -- manually curated list of language servers
  local servers = {
    "bashls",
    "clangd",
    "cmake",
    "cssls",
    "efm",
    "gopls",
    "html",
    "jsonls",
    "pyright",
    "sumneko_lua",
    "vimls",
  }
  for _, server in ipairs(servers) do
    local config = get_server_configuration()
    local has_config, extra_config = pcall(require, "remote.lsp." .. server)
    if has_config then
      config = vim.tbl_extend("force", config, extra_config)
    end
    lspconfig[server].setup(config)
  end
end

load_servers()
