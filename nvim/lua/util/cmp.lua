---@class util.cmp
local M = {}

---Accept a popup completion if visible; otherwise apply inline suggestion.
---Returns true if something was accepted/applied.
---@return boolean
function M.accept()
  if M.visible and M.visible() and M.confirm then
    M.confirm()
    return true
  end
  return M.inline.accept()
end

---Cancel the current completion, undoing the preview from auto_insert
function M.cancel()
  if vim.fn.pumvisible() == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-e>", true, false, true), "n", false)
  end
end

---Trigger completion with given options.
---@param opts? table
function M.complete(opts)
  opts = opts or {}
  local items = opts.items or {}
  if #items == 0 and not opts.force then return false end
  vim.fn.complete(opts.startcol or vim.fn.col "." - 1, opts.items or {})
  if opts.select and vim.fn.pumvisible() == 1 then
    local s = M.info({ "selected" }).selected
    if s == -1 then vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-n>", true, false, true), "n", false) end
  end
end

---Confirm the current completion.
function M.confirm()
  if vim.fn.pumvisible() == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-y>", true, false, true), "n", false)
  end
end

---Hide the completion menu.
function M.hide() return M.cancel() end

---Get info about the current completion menu.
---@param fields? string[]
---@return table
function M.info(fields) return vim.fn.complete_info(fields or { "mode", "items", "selected", "pum_visible" }) end

---Shows the completion menu if not already visible
---@param fields? string[]
function M.show(fields)
  if M.visible() then return end
  if vim.fn.pumvisible() ~= 1 then
    local info = M.info(fields or { "items" })
    if info.items and #info.items > 0 then vim.fn.complete(vim.fn.col "." - 1, info.items) end
  end
end

---Check if the completion menu is visible.
---@return boolean
function M.visible() return vim.fn.pumvisible() == 1 end

---Map a list of action names to their corresponding functions.
---If an action is found and returns a truthy value, the mapping stops.
---If no action is found or all return falsy values, the fallback is executed.
---@param actions string[] # List of action names to map.
---@param fallback? string|fun() # Optional fallback function or string to execute if no action succeeds.
---@return fun(): boolean|string|nil # A function that executes the mapped actions or fallback.
function M.coalesce(actions, fallback)
  return function()
    for _, name in ipairs(actions) do
      local fn = M[name]
        or M.inline[name:match "^inline%.([^.]+)$"]
        or ds.snippet[name]
        or ds.snippet[name:match "^snippet%.([^.]+)$"]
      if type(fn) == "function" then
        local ret = fn()
        if ret then return true end
      end
    end
    return type(fallback) == "function" and fallback() or (type(fallback) == "string" and fallback or nil)
  end
end

---@class util.cmp.inline
M.inline = M.inline or {}

---Apply the currently displayed inline completion candidate.
---Returns true if a candidate was applied (for use in <expr> mappings).
---@param opts? vim.lsp.inline_completion.get.Opts
---@return boolean
function M.inline.accept(opts)
  if M.inline.enabled { bufnr = opts and opts.bufnr } and vim.lsp.inline_completion.get(opts or {}) then
    ds.cmp.hide()
    return true
  end
  return false
end

---Query whether inline completion is available
---Returns false if the feature is not available.
---@return boolean
function M.inline.available() return (vim.lsp.inline_completion and vim.lsp.inline_completion.enable) and true or false end

---Disable inline completion.
---@param filter? vim.lsp.capability.enable.Filter
function M.inline.disable(filter)
  if not M.inline.enabled { bufnr = filter and filter.bufnr } then return end
  M.inline.enable(false, filter)
end

---Enable or disable inline completion for an optional scope filter.
---@param enable? boolean Defaults to true when nil
---@param filter? vim.lsp.capability.enable.Filter
function M.inline.enable(enable, filter)
  vim.schedule(function() vim.lsp.inline_completion.enable(enable, filter) end)
end

---Query whether inline completion is enabled (optionally filtered).
---Returns false if the feature is not available.
---@param filter? vim.lsp.capability.enable.Filter
---@return boolean
function M.inline.enabled(filter) return M.inline.available() and vim.lsp.inline_completion.is_enabled(filter) or false end

---Cycle through inline completion candidates.
---Positive (or nil) count moves forward, negative moves backward.
---@param count? integer
---@param opts? vim.lsp.inline_completion.select.Opts
function M.inline.cycle(count, opts)
  if not M.inline.enabled { bufnr = opts and opts.bufnr } then return end
  count = count or 1
  ds.cmp.hide()
  vim.lsp.inline_completion.select(vim.tbl_extend("force", { count = count }, opts or {}))
end

---Cycle through inline completion candidates.
---Positive (or nil) count moves forward, negative moves backward.
---@param count? integer
---@param opts? vim.lsp.inline_completion.select.Opts
function M.inline.next(count, opts)
  if not M.inline.enabled { bufnr = opts and opts.bufnr } then return false end
  M.inline.cycle(count, opts)
  return true
end

---Toggle inline completion.
---@param filter? vim.lsp.capability.enable.Filter
function M.inline.toggle(filter)
  if not M.inline.enabled { bufnr = filter and filter.bufnr } then return end
  M.inline.enable(not M.inline.is_enabled(filter), filter)
end

return M
