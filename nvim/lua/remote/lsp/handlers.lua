local c = require("ui.theme").colors
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

local M = {}

M.on_attach = function(client, bufnr)
  if client.server_capabilities.declarationProvider then
    -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "" })
  end

  if client.server_capabilities.codeActionProvider then
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr, desc = "lsp: code action" })
  end

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_augroup("lsp_codelens", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = "lsp_codelens",
      once = true,
      buffer = bufnr,
      callback = require("vim.lsp.codelens").refresh,
    })

    vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold" }, {
      group = "lsp_codelens",
      buffer = bufnr,
      callback = require("vim.lsp.codelens").refresh,
    })

    vim.api.nvim_buf_create_user_command(bufnr, "Codelens", function(opts)
      local cmd = unpack(opts.fargs)
      if cmd == "display" then
        vim.lsp.codelens.display()
      elseif cmd == "refresh" then
        vim.lsp.codelens.refresh()
      elseif cmd == "run" then
        vim.lsp.codelens.run()
      else
        error(("Invalid codelens operation: '%s'"):format(cmd))
      end
    end, {
      nargs = "*",
      complete = function(_, line)
        local l = vim.split(line, "%s+")
        local n = #l - 2
        if n == 0 then
          return vim.tbl_filter(function(val)
            return vim.startswith(val, l[2])
          end, { "display", "refresh", "run" })
        end
      end,
    })
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_highlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = "lsp_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.server_capabilities.signatureHelpProvider then
    vim.api.nvim_create_augroup("lsp_signature", { clear = true })

    vim.api.nvim_create_autocmd("CursorHoldI", {
      group = "lsp_signature",
      buffer = bufnr,
      callback = vim.lsp.buf.signature_help,
    })

    vim.keymap.set("i", "<c-h>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
    vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set("n", "ff", function()
      vim.lsp.buf.format { async = true }
    end, { buffer = bufnr, desc = "lsp: format document" })
  end

  if client.server_capabilities.semanticTokensProvider and client.server_capabilities.semanticTokensProvider.full then
    local has_tokens, nvim_semantic_tokens = pcall(require, "nvim-semantic-tokens")
    if has_tokens then
      nvim_semantic_tokens.setup {
        preset = "default",
        highlighters = { require "nvim-semantic-tokens.table-highlighter" },
      }
      vim.api.nvim_create_augroup("lsp_semantic_tokens", { clear = true })

      vim.api.nvim_create_autocmd("TextChanged", {
        group = "lsp_semantic_tokens",
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.semantic_tokens_full()
        end,
      })
      vim.lsp.buf.semantic_tokens_full()
    end
  end

  if client.server_capabilities.documentSymbolProvider then
    pcall(require("nvim-navic").attach, client, bufnr)
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "lsp: Goto definition" })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "lsp: goto type definition" })
  vim.keymap.set("n", "gk", vim.lsp.buf.hover, { buffer = bufnr, desc = "lsp: show documentation" })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "lsp: go to implementation" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "lsp: show references" })
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, { buffer = bufnr, desc = "lsp: show documents symbols" })
  vim.keymap.set("n", "gS", vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "lsp: show workspace symbols" })
  vim.keymap.set("n", "g.", vim.diagnostic.open_float, { buffer = bufnr, desc = "lsp: show line diagnostics" })
  vim.keymap.set("n", "gn", vim.diagnostic.goto_next, { buffer = bufnr, desc = "lsp: next diagnostic" })
  vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "lsp: previous diagnostic" })

  if require("lazy.core.config").plugins["inc-rename.nvim"] ~= nil then
    -- stylua: ignore
    vim.keymap.set("n", "g<leader>", function() return ":IncRename " .. vim.fn.expand "<cword>" end, { buffer = bufnr, expr = true, desc = "lsp: rename" })
  else
    vim.keymap.set("n", "g<leader>", vim.lsp.buf.rename, { buffer = bufnr, desc = "lsp: rename" })
  end

  vim.api.nvim_buf_create_user_command(bufnr, "Workspace", function(opts)
    local cmd = unpack(opts.fargs)
    if cmd == "list" then
      dump(vim.lsp.buf.list_workspace_folders())
    elseif cmd == "add" then
      vim.lsp.buf.add_workspace_folder()
    elseif cmd == "remove" then
      vim.lsp.buf.remove_workspace_folder()
    else
      error(("Invalid workspace operation: '%s'"):format(cmd))
    end
  end, {
    nargs = "*",
    complete = function(_, line)
      local l = vim.split(line, "%s+")
      local n = #l - 2
      if n == 0 then
        return vim.tbl_filter(function(val)
          return vim.startswith(val, l[2])
        end, { "list", "add", "remove" })
      end
    end,
  })
end

M.get_client_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  local has_cmp, cmp = pcall(require, "cmp_nvim_lsp")
  if has_cmp then
    return vim.tbl_deep_extend("keep", capabilities, cmp.default_capabilities())
  end
  return capabilities
end

M.setup = function()
  vim.diagnostic.config {
    severity_sort = true,
    signs = true,
    update_in_insert = false,
    virtual_text = false,
    float = {
      focusable = false,
      show_header = true,
      source = "always",
    },
    underline = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
  }

  local signs = icons.diagnostics
  for type, icon in pairs(signs) do
    local hl = string.format("DiagnosticSign%s", type)
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
  end

  local has_tele, telescope = pcall(require, "telescope.builtin")
  if has_tele then
    vim.lsp.handlers["textDocument/declaration"] = telescope.lsp_definitions
    vim.lsp.handlers["textDocument/definition"] = telescope.lsp_definitions
    vim.lsp.handlers["textDocument/documentSymbol"] = telescope.lsp_document_symbols
    vim.lsp.handlers["textDocument/implementation"] = telescope.lsp_implementations
    vim.lsp.handlers["textDocument/references"] = telescope.lsp_references
    vim.lsp.handlers["textDocument/typeDefinition"] = telescope.lsp_definitions
    vim.lsp.handlers["workspace/symbol"] = telescope.lsp_dynamic_workspace_symbols
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
    groups.new("LspUnnecessary", { fg = c.gray_lighter, italic = true })

    local bufnr = vim.uri_to_bufnr(result.uri)
    if not bufnr then
      return
    end

    local ns_unused = vim.api.nvim_create_namespace "unused"
    vim.api.nvim_buf_clear_namespace(bufnr, ns_unused, 0, -1)
    local real_diags = {}
    for _, diag in pairs(result.diagnostics) do
      if diag.tags == nil then
        diag.tags = {}
      end
      if
        diag.severity == vim.lsp.protocol.DiagnosticSeverity.Hint
        and vim.tbl_contains(diag.tags, vim.lsp.protocol.DiagnosticTag.Unnecessary)
      then
        pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_unused, diag.range.start.line, diag.range.start.character, {
          end_row = diag.range["end"].line,
          end_col = diag.range["end"].character,
          hl_group = "LspUnnecessary",
        })
      else
        table.insert(real_diags, diag)
      end
    end
    result.diagnostics = real_diags
    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
  end
end

return M
