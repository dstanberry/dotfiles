---@diagnostic disable: unused-local
---@class ft.html.render
local M = {}

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.class_values = function(bufnr, ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    end_line = range.row_end,
    end_col = range.col_end,
    conceal = "…",
  })
end

return M
