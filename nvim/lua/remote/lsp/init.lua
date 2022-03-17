-- verify lspconfig is available
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local configs = require "lspconfig/configs"

local util = require "util"

-- vim.lsp.set_log_level("debug")
-- vim.cmd('e '..vim.lsp.get_log_path())

local on_attach_nvim = function(client, bufnr)
  if client.resolved_capabilities.code_lens then
    vim.api.nvim_create_augroup("lsp_document_codelens", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = "lsp_document_codelens",
      once = true,
      pattern = "<buffer>",
      callback = require("vim.lsp.codelens").refresh,
    })

    vim.api.nvim_create_autocmd({ "BufWritePost", "CursorHold" }, {
      group = "lsp_document_codelens",
      pattern = "<buffer>",
      callback = require("vim.lsp.codelens").refresh,
    })
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = "lsp_document_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      pattern = "<buffer>",
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.resolved_capabilities.signature_help then
    vim.api.nvim_create_augroup("lsp_signature", { clear = true })

    vim.api.nvim_create_autocmd("CursorHoldI", {
      group = "lsp_signature",
      pattern = "<buffer>",
      callback = vim.lsp.buf.signature_help,
    })
  end

  local list_workspace_folders = function()
    dump(vim.lsp.buf.list_workspace_folders())
  end

  vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr })
  -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
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

  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "ff", vim.lsp.buf.formatting, { buffer = bufnr })
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("v", "ff", vim.lsp.buf.range_formatting, { buffer = bufnr })
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
  local config
  if vim.fn.match(mod, "null-ls") > 0 then
    require(mod).setup(on_attach_nvim)
  elseif vim.fn.match(mod, "rust_analyzer") > 0 then
    config = require(mod).config or {}
  elseif vim.fn.match(mod, "rust_tools") > 0 then
    local cfg = {
      on_attach = on_attach_nvim,
      capabilities = capabilities,
      flags = { debounce_text_changes = 150 },
    }
    require(mod).setup(vim.tbl_deep_extend("force", cfg, config or {}))
  elseif vim.fn.match(mod, "zk") > 0 then
    config = require(mod).config or {}
    configs.zk = { default_config = config }
    configs.zk.index = require(mod).index
    configs.zk.new = require(mod).new
    lspconfig.zk.setup(vim.tbl_deep_extend("force", {
      capabilities = capabilities,
      flags = { debounce_text_changes = 150 },
      on_attach = function(client, bufnr)
        on_attach_nvim(client, bufnr)
        require(mod).on_attach(client, bufnr)
      end,
    }, config))
  else
    local key = (mod):match "[^%.]*$"
    config = require(mod).config or {}
    servers = vim.tbl_deep_extend("force", servers, { [key] = config })
  end
end

for server, config in pairs(servers) do
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
    on_attach = on_attach_nvim,
  }, config))
end
