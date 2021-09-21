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
    require("util").define_augroup {
      name = "lsp_document_highlight",
      buf = true,
      clear = true,
      autocmds = {
        { event = "CursorHold", pattern = "<buffer>", callback = vim.lsp.buf.document_highlight },
        { event = "CursorMoved", pattern = "<buffer>", callback = vim.lsp.buf.clear_references },
      },
    }
  end

  local show_line_diagnostics = function()
    vim.diagnostic.show_line_diagnostics { border = "single" }
  end

  local goto_next = function()
    vim.diagnostic.goto_next { popup_opts = { border = "single" } }
  end

  local goto_prev = function()
    vim.diagnostic.goto_prev { popup_opts = { border = "single" } }
  end

  local list_workspace_folders = function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end

  nnoremap("ga", vim.lsp.buf.code_action, { buffer = bufnr })
  -- nnoremap("gD", vim.lsp.buf.declaration, { buffer = bufnr })
  nnoremap("gd", vim.lsp.buf.definition, { buffer = bufnr })
  nnoremap("gt", vim.lsp.buf.type_definition, { buffer = bufnr })
  nnoremap("gk", vim.lsp.buf.hover, { buffer = bufnr })
  nnoremap("gi", vim.lsp.buf.implementation, { buffer = bufnr })
  nnoremap("gh", vim.lsp.buf.signature_help, { buffer = bufnr })
  nnoremap("gr", vim.lsp.buf.references, { buffer = bufnr })
  nnoremap("gs", vim.lsp.buf.document_symbol, { buffer = bufnr })
  nnoremap("g/", vim.lsp.buf.rename, { buffer = bufnr })
  nnoremap("g.", show_line_diagnostics, { buffer = bufnr })
  nnoremap("gn", goto_next, { buffer = bufnr })
  nnoremap("gp", goto_prev, { buffer = bufnr })
  nnoremap("<localleader>wl", list_workspace_folders, { buffer = bufnr })
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}
local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
if has_cmp then
  capabilities = cmp.update_capabilities(capabilities)
end

local servers = {
  bashls = {},
  gopls = {},
  jsonls = {},
  pyright = {},
  cmake = { cmd = { "cmake-language-server" } },
  cssls = { cmd = { "css-languageserver", "--stdio" } },
  html = { cmd = { "html-languageserver", "--stdio" } },
  sumneko_lua = require("remote.lsp.sumneko").config,
  vimls = require("remote.lsp.vimls").config,
  ["null-ls"] = require("remote.lsp.null-ls").config or {},
  clangd = {
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
    init_options = { clangdFileStatus = true },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        assist = { importGranularity = "module", importPrefix = "by_self" },
        cargo = { loadOutDirsFromCheck = true },
        procMacro = { enable = true },
      },
    },
  },
}

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
    on_attach = on_attach_nvim,
  }, config))
end
