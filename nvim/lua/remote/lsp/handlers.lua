local M = {}

---@class remote.lsp.config
---@field disabled? boolean
---@field defer_setup? boolean
---@field config? vim.lsp.ClientConfig|vim.lsp.Config|{root_dir: fun(fname: string): string}
---@field setup? fun(config: vim.lsp.ClientConfig|vim.lsp.Config|{root_dir: fun(fname: string): string})

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@alias LspClientFilter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: vim.lsp.Client):boolean}

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

---@param opts LspCommand
function M.execute_command(opts)
  local params = { command = opts.command, arguments = opts.arguments }
  if ds.plugin.is_installed "trouble.nvim" and opts.open then
    require("trouble").open { mode = "lsp_command", params = params }
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

---@param opts? LspClientFilter
---@return vim.lsp.Client[]
function M.get_clients(opts)
  local ret = {} ---@type vim.lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client vim.lsp.Client
      ret = vim.tbl_filter(function(client) return client.supports_method(opts.method, { bufnr = opts.bufnr }) end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@return lsp.ClientCapabilities
function M.get_client_capabilities()
  local extras = {}
  if ds.plugin.is_installed "blink.cmp" then
    local ok, blink_cmp = pcall(require, "blink.cmp")
    extras = ok and blink_cmp.get_lsp_capabilities() or {}
  end
  return vim.deepcopy(vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), extras))
end

---@param opts? { method?: fun(...) }
---@return elem_or_list<fun(client: vim.lsp.Client, init_result: lsp.InitializeResult)>
function M.on_init(opts)
  opts = opts or {}
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
---@param callback? fun()
function M.on_rename(old_fname, new_fname, callback)
  local changes = { files = { { oldUri = vim.uri_from_fname(old_fname), newUri = vim.uri_from_fname(new_fname) } } }
  local clients = vim.lsp.get_clients()

  for _, client in pairs(clients) do
    if client:supports_method "workspace/willRenameFiles" then
      ---@diagnostic disable-next-line: invisible
      local response = client:request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if response and response.result then
        vim.lsp.util.apply_workspace_edit(response.result, client.offset_encoding)
      end
    end
  end
  if callback and type(callback) == "function" then callback() end
  for _, client in ipairs(clients) do
    if client.supports_method "workspace/didRenameFiles" then client.notify("workspace/didRenameFiles", changes) end
  end
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
  -- remove lsp default keymaps
  ds.plugin.keymap_del("n", "gO")
  ds.plugin.keymap_del("n", "gra")
  ds.plugin.keymap_del("n", "gri")
  ds.plugin.keymap_del("n", "grn")
  ds.plugin.keymap_del("n", "grr")
  ds.plugin.keymap_del("n", "grt")

  if client:supports_method("textDocument/codeAction", bufnr) then
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { buffer = bufnr, desc = "lsp: code action" })
  end

  if client:supports_method("textDocument/codeLens", bufnr) then
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

  if client:supports_method "textDocument/completion" then
    vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
  end

  if client:supports_method("textDocument/definition", bufnr) then
    local _definition = vim.lsp.buf.definition
    local _type_definition = vim.lsp.buf.type_definition
    if ds.plugin.is_installed "snacks.nvim" then
      _definition = function() Snacks.picker.lsp_definitions() end
      _type_definition = function() Snacks.picker.lsp_type_definitions { reuse_win = true } end
    end
    vim.keymap.set("n", "gd", _definition, { buffer = bufnr, desc = "lsp: goto definition" })
    vim.keymap.set("n", "gt", _type_definition, { buffer = bufnr, desc = "lsp: goto type definition" })
  end

  if client:supports_method("textDocument/documentHighlight", bufnr) then
    local _references = vim.lsp.buf.references
    if ds.plugin.is_installed "snacks.nvim" then _references = function() Snacks.picker.lsp_references() end end
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

  if client:supports_method("textDocument/formatting", bufnr) then
    ds.plugin.keymap_set({ "n", "v" }, "ff", ds.format.format, { buffer = bufnr, desc = "lsp: format document" })
  end

  if client:supports_method("textDocument/hover", bufnr) then
    vim.keymap.set("n", "gk", vim.lsp.buf.hover, { buffer = bufnr, desc = "lsp: show documentation" })
  end

  if client:supports_method "textDocument/implementation" then
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "lsp: goto implementation" })
  end

  if client:supports_method("textDocument/inlayHint", bufnr) then
    local _inlay_hints = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end
    vim.keymap.set("n", "g<bs>", _inlay_hints, { buffer = bufnr, desc = "lsp: toggle inlay hints" })
  end

  if client:supports_method("textDocument/rename", bufnr) then
    vim.keymap.set("n", "g<leader>", vim.lsp.buf.rename, { buffer = bufnr, desc = "lsp: rename symbol" })
  end

  if client:supports_method("textDocument/signatureHelp", bufnr) then
    -- NOTE: handled by |noice.nvim|
    -- local lsp_signature = vim.api.nvim_create_augroup("lsp_signature", { clear = true })
    -- vim.api.nvim_create_autocmd("CursorHoldI", {
    --   group = lsp_signature,
    --   desc = "LSP: Show signature help",
    --   buffer = bufnr,
    --   callback = vim.lsp.buf.signature_help,
    -- })
    vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
    vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "lsp: signature help" })
  end

  if client:supports_method("textDocument/documentSymbol", bufnr) then
    local _symbols = function() vim.lsp.buf.workspace_symbol "" end
    vim.keymap.set("n", "gs", vim.lsp.buf.document_symbol, { buffer = bufnr, desc = "lsp: show documents symbols" })
    vim.keymap.set("n", "gw", _symbols, { buffer = bufnr, desc = "lsp: show workspace symbols" })
  end

  if client:supports_method("workspace/willRenameFiles", bufnr) then
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

  local _previous = function() vim.diagnostic.jump { count = -1 } end
  local _next = function() vim.diagnostic.jump { count = 1 } end
  vim.keymap.set("n", "g.", vim.diagnostic.open_float, { buffer = bufnr, desc = "lsp: show line diagnostics" })
  vim.keymap.set("n", "gn", _next, { buffer = bufnr, desc = "lsp: next diagnostic" })
  vim.keymap.set("n", "gp", _previous, { buffer = bufnr, desc = "lsp: previous diagnostic" })
end

---@param opts? LspClientFilter
function M.format(opts)
  local default_fmt = ds.format.default_formatter
  local ok, fmt = pcall(require, default_fmt.modname)
  if not (default_fmt.name and default_fmt.modname) then
    if not ok then
      ds.warn(
        "Failed to load formatter `" .. default_fmt.name .. "`\nFalling back to native lsp formatter.",
        { title = "LSP: Formatting" }
      )
    end
    vim.lsp.buf.format(opts)
    return
  end
  opts = vim.tbl_deep_extend("force", {}, opts or {}, ds.plugin.get_opts(default_fmt.name).default_format_opts or {})
  if ok then
    opts.formatters = {}
    fmt.format(opts)
  end
end

---@param opts? util.format.formatter | {filter?: (string|LspClientFilter)}
function M.formatter(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter LspClientFilter
  ---@type util.format.formatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf) M.format(ds.plugin.deep_merge({}, filter, { bufnr = buf })) end,
    sources = function(buf)
      local clients = M.get_clients(ds.plugin.deep_merge({}, filter, { bufnr = buf }))
      local ret = vim.tbl_filter(function(client) ---@param client vim.lsp.Client
        return client.supports_method "textDocument/formatting" or client.supports_method "textDocument/rangeFormatting"
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client) return client.name end, ret)
    end,
  }
  return ds.plugin.deep_merge(ret, opts) --[[@as util.format.formatter]]
end

function M.setup()
  vim.diagnostic.config {
    severity_sort = true,
    update_in_insert = false,
    virtual_text = false,
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    float = {
      border = vim.tbl_map(function(icon) return { icon, "FloatBorderSB" } end, ds.icons.border.Default),
      focusable = false,
      show_header = true,
      source = true,
    },
    jump = {
      on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = "cursor", focus = false } end,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = ds.icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = ds.icons.diagnostics.Warn,
        [vim.diagnostic.severity.HINT] = ds.icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = ds.icons.diagnostics.Info,
      },
    },
  }

  if ds.plugin.is_installed "snacks.nvim" then
    local _document_symbols = function() Snacks.picker.lsp_symbols() end
    local _workspace_symbols = function() Snacks.picker.lsp_workspace_symbols() end
    vim.lsp.handlers["textDocument/documentSymbol"] = _document_symbols
    vim.lsp.handlers["workspace/symbol"] = _workspace_symbols
  end
end

return M
