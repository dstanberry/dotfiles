-- verify lspconfig is available
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local util = require "util"

-- enable debugging
-- vim.lsp.set_log_level("debug")
-- vim.cmd('e '..vim.lsp.get_log_path())

local on_attach_nvim = function(client, bufnr)
  local nnoremap = util.map.nnoremap
  local vnoremap = util.map.vnoremap

  if client.resolved_capabilities.code_lens then
    util.define_augroup {
      name = "lsp_document_codelens",
      buf = true,
      clear = true,
      autocmds = {
        {
          event = "BufEnter",
          once = true,
          pattern = "<buffer>",
          callback = require("vim.lsp.codelens").refresh,
        },
        {
          event = { "BufWritePost", "CursorHold" },
          pattern = "<buffer>",
          callback = require("vim.lsp.codelens").refresh,
        },
      },
    }
  end

  if client.resolved_capabilities.document_highlight then
    util.define_augroup {
      name = "lsp_document_highlight",
      buf = true,
      clear = true,
      autocmds = {
        {
          event = "CursorHold",
          pattern = "<buffer>",
          callback = vim.lsp.buf.document_highlight,
        },
        {
          event = "CursorMoved",
          pattern = "<buffer>",
          callback = vim.lsp.buf.clear_references,
        },
      },
    }
  end

  util.define_augroup {
    name = "lsp_signature",
    buf = true,
    clear = true,
    autocmds = {
      {
        event = "CursorHoldI",
        pattern = "<buffer>",
        callback = vim.lsp.buf.signature_help,
      },
    },
  }
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
  nnoremap("gn", vim.diagnostic.goto_next, { buffer = bufnr })
  nnoremap("gp", vim.diagnostic.goto_prev, { buffer = bufnr })
  nnoremap("<localleader>wl", list_workspace_folders, { buffer = bufnr })
  nnoremap("<localleader>wa", vim.lsp.buf.add_workspace_folder, { buffer = bufnr })
  nnoremap("<localleader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = bufnr })

  if client.resolved_capabilities.document_formatting then
    nnoremap("ff", vim.lsp.buf.formatting, { buffer = bufnr })
  end
  if client.resolved_capabilities.document_range_formatting then
    vnoremap("ff", vim.lsp.buf.range_formatting, { buffer = bufnr })
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
  cmake = {},
  cssls = {},
  html = {},
}

local configurations = vim.api.nvim_get_runtime_file("lua/remote/lsp/servers/*.lua", true)
for _, file in ipairs(configurations) do
  local mod = util.get_module_name(file)
  local config = require(mod).config or {}
  local key = (mod):match "[^%.]*$"
  servers = vim.tbl_deep_extend("force", servers, { [key] = config })
end

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
    on_attach = on_attach_nvim,
  }, config))
end
