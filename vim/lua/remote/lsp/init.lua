---------------------------------------------------------------
-- => Language Server Protocol Configuration
---------------------------------------------------------------
-- verify lspconfig is available
local has_lsp, lspconfig = pcall(require, 'lspconfig')
local lspconfig_util = pcall(require, 'lspconfig.util')
if not has_lsp then
  return
end

-- add language servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach_vim = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = {noremap = true, silent = true}
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  end

  require('completion').on_attach()
end

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
  return lspconfig_util.find_git_ancestor(fname) or
           lspconfig.util.root_pattern("yarn.lock") or
           lspconfig.util.root_pattern("package.json") or
           lspconfig_util.path.dirname(fname)
end

-- add lua language server
require('nlua.lsp.nvim').setup(lspconfig, {
  capabilities = capabilities,
  on_attach = on_attach_vim,
  root_dir = project_root,
  diagnostics = {globals = {"vim"}},
  workspace = {library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true}}
})

-- efm-langserver configuration
local eslint = require 'remote.lsp.linters.eslint'
local flake = require 'remote.lsp.linters.flake8'

local isort = require 'remote.lsp.formatters.isort'
local luafmt = require 'remote.lsp.formatters.luafmt'
local prettier = require 'remote.lsp.formatters.prettier'
local yapf = require 'remote.lsp.formatters.yapf'

local languages = {
  lua = {luafmt},
  javascript = {prettier, eslint},
  yaml = {prettier},
  html = {prettier},
  scss = {prettier},
  css = {prettier},
  markdown = {prettier},
  python = {flake, isort, yapf}
}

lspconfig.efm.setup {
  root_dir = project_root,
  filetypes = vim.tbl_keys(languages),
  init_options = {documentFormatting = true, codeAction = true},
  settings = {
    languages = languages,
    log_level = 1,
    log_file = "~/.config/efm.log"
  },
  capabilities = capabilities,
  on_attach = on_attach_vim
}

-- shellcheck/shfmt breaks efm-langserver
lspconfig.diagnosticls.setup {
  on_attach = on_attach_vim,
  capabilities = capabilities,
  cmd = {"diagnostic-languageserver", "--stdio"},
  filetypes = {"sh"},
  init_options = {
    linters = {
      shellcheck = {
        command = "shellcheck",
        debounce = 100,
        args = {"--format", "json", "-"},
        sourceName = "shellcheck",
        parseJson = {
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "${message} [${code}]",
          security = "level"
        },
        securities = {
          error = "error",
          warning = "warning",
          info = "info",
          style = "hint"
        }
      }
    },
    filetypes = {sh = "shellcheck", zsh = "shellcheck"},
    formatters = {
      shfmt = {command = "shfmt", args = {"-i", "2", "-bn", "-ci", "-sr"}},
      prettier = {
        command = "prettier",
        args = {"--stdin-filepath", "%filepath"}
      }
    },
    formatFiletypes = {sh = "shfmt", zsh = "shfmt"}
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
