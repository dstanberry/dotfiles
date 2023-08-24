local icons = require "ui.icons"

local M = {}

M.on_init = function(opts)
  return function(client)
    local default_request = client.rpc.request
    function client.rpc.request(method, params, handler, ...)
      opts = vim.F.if_nil(opts, {})
      local default_handler = handler
      local preprocessor = opts[method]
      handler = preprocessor ~= nil
          and function(...)
            if type(preprocessor) == "function" then preprocessor(...) end
            return default_handler(...)
          end
        or default_handler
      return default_request(method, params, handler, ...)
    end
  end
end

M.on_attach = function(client, bufnr)
  -- NOTE: "gD" used by |glance.nvim|
  -- if client.server_capabilities.declarationProvider then
  -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "" })
  -- end

  if client.server_capabilities.codeActionProvider then
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr, desc = "lsp: code action" })
    vim.keymap.set(
      "n",
      "gA",
      function() vim.lsp.buf.code_action { context = { only = { "source" }, diagnostics = {} } } end,
      { buffer = bufnr, desc = "lsp: source action" }
    )
  end

  if client.server_capabilities.codeLensProvider then
    local lsp_codelens = vim.api.nvim_create_augroup("lsp_codelens", { clear = true })

    vim.api.nvim_create_autocmd("BufEnter", {
      group = lsp_codelens,
      once = true,
      buffer = bufnr,
      callback = require("vim.lsp.codelens").refresh,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lsp_codelens,
      buffer = bufnr,
      callback = require("vim.lsp.codelens").refresh,
    })

    vim.keymap.set("n", "gl", function()
      vim.ui.select({ "display", "refresh", "run" }, {
        prompt = "Code Lens",
        format_item = function(item) return "Code lens " .. item end,
      }, function(choice)
        if choice == "display" then
          vim.lsp.codelens.display()
        elseif choice == "refresh" then
          vim.lsp.codelens.refresh()
        elseif choice == "run" then
          vim.lsp.codelens.run()
        end
      end)
    end, { buffer = bufnr, desc = "lsp: code lens" })
  end

  if client.server_capabilities.documentHighlightProvider then
    local lsp_highlight = vim.api.nvim_create_augroup("lsp_highlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = lsp_highlight,
      buffer = bufnr,
      callback = function() vim.lsp.buf.document_highlight() end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = lsp_highlight,
      buffer = bufnr,
      callback = function() vim.lsp.buf.clear_references() end,
    })
  end

  if client.server_capabilities.documentFormattingProvider then
    if vim.fn.maparg "ff" == "" then
      vim.keymap.set(
        "n",
        "ff",
        function() vim.lsp.buf.format { async = true } end,
        { buffer = bufnr, desc = "lsp: format document" }
      )
    end
  end

  if client.server_capabilities.inlayHintProvider then
    vim.keymap.set(
      "n",
      "g<bs>",
      function() vim.lsp.buf.inlay_hint(bufnr) end,
      { buffer = bufnr, desc = "lsp: toggle inlay hints" }
    )
  end

  if client.server_capabilities.signatureHelpProvider then
    -- NOTE: handled by |noice.nvim|
    -- local lsp_signature = vim.api.nvim_create_augroup("lsp_signature", { clear = true })
    -- vim.api.nvim_create_autocmd("CursorHoldI", {
    --   group = lsp_signature,
    --   buffer = bufnr,
    --   callback = vim.lsp.buf.signature_help,
    -- })
    vim.keymap.set("i", "<c-h>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
    vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "lsp: goto definition" })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "lsp: goto type definition" })
  vim.keymap.set("n", "gk", vim.lsp.buf.hover, { buffer = bufnr, desc = "lsp: show documentation" })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "lsp: goto implementation" })
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
      dump_with_title("LSP Workspace(s)", vim.lsp.buf.list_workspace_folders())
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
        return vim.tbl_filter(function(val) return vim.startswith(val, l[2]) end, { "list", "add", "remove" })
      end
    end,
  })
end

M.get_client_capabilities = function()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if ok then capabilities = vim.tbl_deep_extend("keep", capabilities, cmp_nvim_lsp.default_capabilities()) end
  capabilities = vim.tbl_deep_extend("keep", capabilities, {
    textDocument = {
      completion = {
        completionItem = {
          commitCharactersSupport = true,
          deprecatedSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          preselectSupport = true,
          snippetSupport = true,
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
          },
        },
      },
      foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
    },
    workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
  })
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
      severity = { min = vim.diagnostic.severity.HINT },
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
end

return M
