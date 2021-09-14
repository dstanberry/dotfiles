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

local on_attach_nvim = function(client, bufnr)
  local map = require "util.map"
  local nnoremap = map.nnoremap
  local vnoremap = map.vnoremap

  if client.resolved_capabilities.document_highlight then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end

  nnoremap("ga", vim.lsp.buf.code_action, { buffer = bufnr })
  nnoremap("gD", vim.lsp.buf.declaration, { buffer = bufnr })
  nnoremap("gd", vim.lsp.buf.definition, { buffer = bufnr })
  nnoremap("gt", vim.lsp.buf.type_definition, { buffer = bufnr })
  nnoremap("gk", vim.lsp.buf.hover, { buffer = bufnr })
  nnoremap("gi", vim.lsp.buf.implementation, { buffer = bufnr })
  nnoremap("gh", vim.lsp.buf.signature_help, { buffer = bufnr })
  nnoremap("gr", vim.lsp.buf.references, { buffer = bufnr })
  nnoremap("gs", vim.lsp.buf.document_symbol, { buffer = bufnr })
  nnoremap("g/", vim.lsp.buf.rename, { buffer = bufnr })
  nnoremap("g.", function()
    vim.lsp.diagnostic.show_line_diagnostics { border = "single" }
  end, { buffer = bufnr })
  nnoremap("gn", function()
    vim.lsp.diagnostic.goto_next { popup_opts = { border = "single" } }
  end, {
    buffer = bufnr,
  })
  nnoremap("gp", function()
    vim.lsp.diagnostic.goto_prev { popup_opts = { border = "single" } }
  end, {
    buffer = bufnr,
  })
  nnoremap("gl", vim.lsp.diagnostic.set_loclist)
  nnoremap("<localleader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, {
    buffer = bufnr,
  })
  nnoremap("<localleader>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr })
  nnoremap("<localleader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr })

  if client.resolved_capabilities.document_formatting then
    nnoremap("ff", vim.lsp.buf.formatting, { buffer = bufnr })
  end
  if client.resolved_capabilities.document_range_formatting then
    vnoremap("ff", vim.lsp.buf.range_formatting, { buffer = bufnr })
  end

  local has_sig, lspsignature = pcall(require, "lsp_signature")
  if has_sig then
    lspsignature.on_attach {
      bind = true,
      doc_lines = 2,
      floating_window = true,
      fix_pos = false,
      hint_enable = false,
      handler_opts = {
        border = "single",
      },
    }
  end
end

local function get_server_configuration()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    capabilities = cmp.update_capabilities(capabilities)
  end
  return {
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
    on_attach = on_attach_nvim,
  }
end

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
  "rust_analyzer",
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
