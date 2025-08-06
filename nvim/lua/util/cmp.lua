---@class util.cmp
local M = {}

---Cancel the current completion, undoing the preview from auto_insert
function M.cancel() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-e>", true, false, true), "n", false) end

---Trigger completion with given options.
---@param opts? table
function M.complete(opts)
  opts = opts or {}
  vim.fn.complete(opts.pos or vim.fn.col "." - 1, opts.items or {})
end

---Confirm the current completion.
function M.confirm() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-y>", true, false, true), "n", false) end

---Hide the completion menu.
function M.hide() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-e>", true, false, true), "n", false) end

---Get info about the current completion menu.
---@return table
function M.info() return vim.fn.complete_info { "mode", "items", "selected", "pum_visible" } end

---Shows the completion menu if not already visible
function M.show()
  if vim.fn.pumvisible() ~= 1 then
    local info = vim.fn.complete_info { "items", "selected", "pum_visible" }
    if info.items and #info.items > 0 then vim.fn.complete(vim.fn.col "." - 1, info.items) end
  end
end

---Check if the completion menu is visible.
---@return boolean
function M.visible() return vim.fn.pumvisible() == 1 end

return M
