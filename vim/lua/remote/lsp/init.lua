---------------------------------------------------------------
-- => Language Server Protocol Configuration
---------------------------------------------------------------
-- verify lspconfig and nlua-nvim are available
local has_lsp, lspconfig = pcall(require, 'lspconfig')
local has_nlua, nluaconfig = pcall(require, 'nlua.lsp.nvim')
if not has_lsp and not has_nlua then
  return
end

-- enable debugging
-- vim.lsp.set_log_level("debug")

-- identify project root directory
local project_root = function(fname)
  if string.find(vim.fn.fnamemodify(fname, ":p"), ".config") then
    return vim.fn.expand("~/.config")
  end
  return lspconfig.util.path.dirname(fname)
end
-- define buffer local features
local on_attach_nvim = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  -- define symbol highlighting if supported by server
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
  -- define keybinds for code actions / diagnostics
  local opts = {noremap = true, silent = true}
  buf_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  buf_set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", opts)
  buf_set_keymap("n", "g/", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  buf_set_keymap("n", "g.",
                 "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", opts)
  buf_set_keymap("n", "gn", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
  buf_set_keymap("n", "gp", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
  buf_set_keymap("n", "gl",
                 "<cmd>call functions#vim_lsp_diagnostic_set_loclist()<cr>",
                 opts)
  buf_set_keymap("n", '<localleader>wl',
                 "<cmd>lua P(vim.lsp.buf.list_workspace_folders())<CR>", opts)
  buf_set_keymap("n", '<localleader>wa',
                 "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", '<localleader>wr',
                 "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  -- define keybind for document formatting if supported by server
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<cr>",
                   opts)
  end
end

-- diagnostic symbols and highlight groups
vim.fn.sign_define("LspDiagnosticsSignError",
{text = ' ', texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
{text = ' ', texthl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
{text = '', texthl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",
{text = '', texthl = "LspDiagnosticsSignHint"})

-- (nvim-lsputils) set enhancements
vim.lsp.handlers['textDocument/codeAction'] =
  require'lsputil.codeAction'.code_action_handler
vim.lsp.handlers['textDocument/references'] =
  require'lsputil.locations'.references_handler
vim.lsp.handlers['textDocument/definition'] =
  require'lsputil.locations'.definition_handler
vim.lsp.handlers['textDocument/declaration'] =
  require'lsputil.locations'.declaration_handler
vim.lsp.handlers['textDocument/typeDefinition'] =
  require'lsputil.locations'.typeDefinition_handler
vim.lsp.handlers['textDocument/implementation'] =
  require'lsputil.locations'.implementation_handler
vim.lsp.handlers['textDocument/documentSymbol'] =
  require'lsputil.symbols'.document_handler
vim.lsp.handlers['workspace/symbol'] =
  require'lsputil.symbols'.workspace_handler
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with( -- set diagnostics options
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    signs = true,
    update_in_insert = false,
    virtual_text = {prefix = '▪', spacing = 4}
  })

-- pack lsp configuration
local function get_server_configuration()
  -- enable snippet support
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport =
    {properties = {'documentation', 'detail', 'additionalTextEdits'}}
  return {
    capabilities = capabilities,
    on_attach = on_attach_nvim,
    root_dir = project_root
  }
end

-- load defined servers
local function load_servers()
  -- manually curated list of language servers
  local servers = {
    'bashls', 'clangd', 'cmake', 'cssls', 'efm', 'html', 'jsonls', 'sumneko_ls',
    'pyright', 'vimls'
  }
  for _, server in ipairs(servers) do
    local config = get_server_configuration()
    if server == 'sumneko_ls' then
      local sumneko = require 'remote.lsp.sumneko'
      config = vim.tbl_extend('force', config, sumneko)
      nluaconfig.setup(lspconfig, config)
    else
      local has_config, ls = pcall(require, 'remote.lsp.' .. server)
      if has_config then
        config = vim.tbl_extend('force', config, ls)
      end
      lspconfig[server].setup(config)
    end
  end
end

load_servers()
