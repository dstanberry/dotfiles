---@diagnostic disable: unused-local
---@class ft.python.render
local M = {}

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range { start_row: integer, start_col: integer, end_row: integer, end_col: integer }
function M.string_init(bufnr, ns, capture_node, capture_text, range)
  local pre = capture_text:gsub([["]], "")
  if pre == "f" then
    vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
      end_col = range.col_start + 1,
      hl_group = "@function.macro",
    })
  end
end

return M
