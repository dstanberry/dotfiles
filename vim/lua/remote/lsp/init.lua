---------------------------------------------------------------
-- => Language Server Protocol Configuration
---------------------------------------------------------------
-- verify lspconfig and nlua-nvim are available
local has_lsp, lspconfig = pcall(require, 'lspconfig')
local has_nlua, nluaconfig = pcall(require, 'nlua.lsp.nvim')
if not has_lsp and not has_nlua then
  return
end

-- define lsp capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach_vim = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = {noremap = true, silent = true}
  if client.resolved_capabilities.document_formatting or
    client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  end

  buf_set_keymap("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  buf_set_keymap("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  buf_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  buf_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", opts)
  buf_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  buf_set_keymap("n", "gf", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  buf_set_keymap("n", "gn", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", opts)
  buf_set_keymap("n", "gp", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", opts)
  buf_set_keymap("n", "gl",
                 "<cmd>call functions#vim_lsp_diagnostic_set_loclist()<cr>",
                 opts)

  require('completion').on_attach()
end

-- add language servers
local servers = {'bashls', 'jsonls', 'pyright', 'vimls'}
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
    on_attach = on_attach_vim
  }
end

local project_root = function(fname)
  if string.find(vim.fn.fnamemodify(fname, ":p"), ".config") then
    return vim.fn.expand("~/.config")
  end
  return lspconfig.util.path.dirname(fname)
end

-- add lua language server
nluaconfig.setup(lspconfig, {
  capabilities = capabilities,
  on_attach = on_attach_vim,
  root_dir = project_root,
  diagnostics = {globals = {"vim"}},
  workspace = {library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true}}
})

-- linter/formatter configuration
local eslint = require 'remote.lsp.linters.eslint'
local flake = require 'remote.lsp.linters.flake8'
local shellcheck = require 'remote.lsp.linters.shellcheck'

local isort = require 'remote.lsp.formatters.isort'
local luafmt = require 'remote.lsp.formatters.luafmt'
local prettier = require 'remote.lsp.formatters.prettier'
local shfmt = require 'remote.lsp.formatters.shfmt'
local yapf = require 'remote.lsp.formatters.yapf'

local languages = {
  css = {prettier},
  html = {prettier},
  javascript = {prettier, eslint},
  lua = {luafmt},
  markdown = {prettier},
  python = {flake, isort, yapf},
  yaml = {prettier}
}

lspconfig.efm.setup {
  root_dir = project_root,
  filetypes = vim.tbl_keys(languages),
  init_options = {documentFormatting = true, codeAction = true},
  settings = {languages = languages, log_level = 1},
  capabilities = capabilities,
  on_attach = on_attach_vim
}

local lfiles = {sh = "shellcheck"}
local linters = {shellcheck = shellcheck}

local ffiles = {sh = "shfmt"}
local formatters = {shfmt = shfmt}

-- shellcheck/shfmt breaks efm-langserver
lspconfig.diagnosticls.setup {
  on_attach = on_attach_vim,
  capabilities = capabilities,
  cmd = {"diagnostic-languageserver", "--stdio"},
  filetypes = vim.tbl_keys(ffiles),
  init_options = {
    filetypes = lfiles,
    linters = linters,
    formatFiletypes = ffiles,
    formatters = formatters
  }
}

-- set enhancements
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
