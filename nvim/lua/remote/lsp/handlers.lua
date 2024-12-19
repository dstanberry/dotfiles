local M = {}

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute_command(opts)
  local params = { command = opts.command, arguments = opts.arguments }
  if ds.plugin.is_installed "trouble.nvim" and opts.open then
    require("trouble").open { mode = "lsp_command", params = params }
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

M.get_client_capabilities = function()
  local ok, blink = pcall(require, "blink.cmp")
  return vim.deepcopy(
    vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      ok and blink.get_lsp_capabilities() or {}
    )
  )
end

---@param opts? { method?: fun(...) }
M.on_init = function(opts)
  opts = opts or {}
  ---@param client vim.lsp.Client
  return function(client)
    local default_request = client.rpc.request
    function client.rpc.request(method, params, handler, ...)
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

---@param old_fname string
---@param new_fname string
---@param rename_fn? fun()
M.on_rename = function(old_fname, new_fname, rename_fn)
  local buf = vim.fn.bufnr(old_fname)
  local renamed = false
  for _, c in pairs(vim.lsp.get_clients { bufnr = buf }) do
    if c.supports_method "workspace/willRenameFiles" then
      ---@diagnostic disable-next-line: invisible
      local res = c.request_sync("workspace/willRenameFiles", {
        files = { { oldUri = vim.uri_from_fname(old_fname), newUri = vim.uri_from_fname(new_fname) } },
      }, 1000, 0)
      if res and res.result then
        renamed = true
        vim.lsp.util.apply_workspace_edit(res.result, c.offset_encoding)
      end
    end
  end
  if rename_fn and type(rename_fn) == "function" then rename_fn() end
  if not renamed then ds.warn("Workspace cannot be updated to match file rename", { title = "LSP" }) end
end

---@param client vim.lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
  if client.server_capabilities.codeActionProvider then
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr, desc = "lsp: code action" })
  end

  if client.server_capabilities.codeLensProvider then
    local _lens = function()
      vim.ui.select({ "display", "refresh", "run" }, {
        prompt = "Code Lens",
        format_item = function(item) return "Code lens " .. item end,
      }, function(choice)
        if choice == "display" then
          vim.lsp.codelens.display(vim.lsp.codelens.get(bufnr), bufnr, client.id)
        elseif choice == "refresh" then
          vim.lsp.codelens.refresh { bufnr = bufnr }
        elseif choice == "run" then
          vim.lsp.codelens.run()
        end
      end)
    end
    vim.keymap.set("n", "gl", _lens, { buffer = bufnr, desc = "lsp: code lens" })

    local codelens = ds.augroup "lsp_codelens"
    vim.api.nvim_create_autocmd("BufEnter", {
      group = codelens,
      once = true,
      buffer = bufnr,
      desc = "LSP: Code Lens refresh",
      callback = function(args) pcall(vim.lsp.codelens.refresh, { bufnr = args.buf }) end,
    })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = codelens,
      buffer = bufnr,
      desc = "LSP: Code Lens refresh",
      callback = function(args) pcall(vim.lsp.codelens.refresh, { bufnr = args.buf }) end,
    })
  end

  if client.server_capabilities.definitionProvider then
    local _definition = vim.lsp.buf.definition
    local _type_definition = vim.lsp.buf.type_definition
    if ds.plugin.is_installed "telescope.nvim" then
      _definition = function() require("telescope.builtin").lsp_definitions { reuse_win = true } end
      _type_definition = function() require("telescope.builtin").lsp_type_definitions { reuse_win = true } end
    end
    vim.keymap.set("n", "gd", _definition, { buffer = bufnr, desc = "lsp: goto definition" })
    vim.keymap.set("n", "gt", _type_definition, { buffer = bufnr, desc = "lsp: goto type definition" })
  end

  if client.server_capabilities.documentFormattingProvider then
    -- INFO: skip keymap assignment if already defined
    local _format = function() vim.lsp.buf.format { async = true } end
    if vim.fn.maparg "ff" == "" then
      vim.keymap.set("n", "ff", _format, { buffer = bufnr, desc = "lsp: format document" })
    end
  end

  if client.server_capabilities.documentHighlightProvider then
    local _references = vim.lsp.buf.references
    if ds.plugin.is_installed "telescope.nvim" then
      _references = function() require("telescope.builtin").lsp_references() end
    end
    vim.keymap.set("n", "gr", _references, { buffer = bufnr, desc = "lsp: show references" })

    local doc_highlight = ds.augroup "lsp_dochighlight"
    vim.api.nvim_create_autocmd("CursorHold", {
      group = doc_highlight,
      buffer = bufnr,
      desc = "LSP: Highlight symbol",
      callback = function() vim.lsp.buf.document_highlight() end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = doc_highlight,
      buffer = bufnr,
      desc = "LSP: Clear highlighted symbol",
      callback = function() vim.lsp.buf.clear_references() end,
    })
  end

  if client.server_capabilities.hoverProvider then
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, { buffer = bufnr, desc = "lsp: show documentation" })
  end

  if client.server_capabilities.inlayHintProvider then
    local _inlay_hints = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end
    vim.keymap.set("n", "g<bs>", _inlay_hints, { buffer = bufnr, desc = "lsp: toggle inlay hints" })
  end

  if client.server_capabilities.renameProvider then
    if ds.plugin.is_loaded "inc-rename.nvim" then
      local _rename = function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end
      vim.keymap.set("n", "g<leader>", _rename, { buffer = bufnr, expr = true, desc = "lsp: rename" })
    else
      vim.keymap.set("n", "g<leader>", vim.lsp.buf.rename, { buffer = bufnr, desc = "lsp: rename" })
    end
  end

  if client.supports_method "workspace/willRenameFiles" then
    local _rename = function()
      vim.ui.input({ prompt = "New filename: " }, function(name)
        if not name then return end
        local old_fname = vim.api.nvim_buf_get_name(0)
        local new_fname = string.format("%s/%s", vim.fs.dirname(old_fname), name)
        ---@diagnostic disable-next-line: invisible
        local res = client.request_sync("workspace/willRenameFiles", {
          files = {
            {
              oldUri = vim.uri_from_fname(old_fname),
              newUri = vim.uri_from_fname(new_fname),
            },
          },
        }, 1000, 0)
        if res and res.result then vim.lsp.util.apply_workspace_edit(res.result, client.offset_encoding) end
        vim.lsp.util.rename(old_fname, new_fname)
        vim.cmd.edit "%"
      end)
    end
    vim.keymap.set("n", "g-", _rename, { buffer = bufnr, desc = "lsp: rename file" })
  end

  if client.server_capabilities.signatureHelpProvider then
    -- NOTE: handled by |noice.nvim|
    -- local lsp_signature = vim.api.nvim_create_augroup("lsp_signature", { clear = true })
    -- vim.api.nvim_create_autocmd("CursorHoldI", {
    --   group = lsp_signature,
    --   desc = "LSP: Show signature help",
    --   buffer = bufnr,
    --   callback = vim.lsp.buf.signature_help,
    -- })
    vim.keymap.set("i", "<c-h>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
    vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
  end

  local _symbols = function() vim.lsp.buf.workspace_symbol "" end
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "lsp: goto implementation" })
  vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, { buffer = bufnr, desc = "lsp: show documents symbols" })
  vim.keymap.set("n", "gw", _symbols, { buffer = bufnr, desc = "lsp: show workspace symbols" })

  local _previous = function() vim.diagnostic.jump { count = -1, float = true } end
  local _next = function() vim.diagnostic.jump { count = 1, float = true } end
  vim.keymap.set("n", "g.", vim.diagnostic.open_float, { buffer = bufnr, desc = "lsp: show line diagnostics" })
  vim.keymap.set("n", "gn", _next, { buffer = bufnr, desc = "lsp: next diagnostic" })
  vim.keymap.set("n", "gp", _previous, { buffer = bufnr, desc = "lsp: previous diagnostic" })
end

M.run_code_action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action {
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      }
    end
  end,
})

M.setup = function()
  vim.diagnostic.config {
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ds.icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = ds.icons.diagnostics.Warn,
        [vim.diagnostic.severity.HINT] = ds.icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = ds.icons.diagnostics.Info,
      },
    },
    update_in_insert = false,
    virtual_text = false,
    --- @class vim.diagnostic.Opts.Float
    ---@field border? string | table[]
    float = {
      border = ds.map(ds.icons.border.Default, function(icon) return { icon, "FloatBorderSB" } end),
      focusable = false,
      show_header = true,
      source = true,
    },
    underline = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
  }

  local _document_symbols = function() require("telescope.builtin").lsp_document_symbols() end
  local _workspace_symbols = function() require("telescope.builtin").lsp_dynamic_workspace_symbols() end
  vim.lsp.handlers["textDocument/documentSymbol"] = _document_symbols
  vim.lsp.handlers["workspace/symbol"] = _workspace_symbols

  -- TODO: remove after functionality is merged upstream
  -- https://github.com/neovim/neovim/issues/19649#issuecomment-1327287313
  -- neovim does not currently correctly report the related locations for diagnostics.
  local show_related_locations = function(diag)
    local related_info = diag.relatedInformation
    if not related_info or #related_info == 0 then return diag end
    for _, info in ipairs(related_info) do
      diag.message = ("%s\n%s(%d:%d)%s"):format(
        diag.message,
        vim.fs.basename(info.location.uri),
        info.location.range.start.line + 1,
        info.location.range.start.character + 1,
        info.message and info.message ~= "" and (": %s"):format(info.message) or ""
      )
    end
    return diag
  end
  local diag_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
  ---@diagnostic disable-next-line: redundant-parameter
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
    result.diagnostics = vim.tbl_map(show_related_locations, result.diagnostics)
    diag_handler(err, result, ctx, config)
  end
end

return M
