---@class ft.python
---@field render ft.python.render
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("ft.python." .. k)
    return rawget(t, k)
  end,
})

local NAMESPACE_ID = vim.api.nvim_create_namespace "ds_python_extmarks"

---@param bufnr number
---@param def "method"|"class"
---@param end_row? number
---@return TSNode[]
function M.get_defs(bufnr, def, end_row)
  local query_tree = vim.treesitter.query.parse(
    "python",
    [[
      (function_definition name: (identifier) @method)
      (class_definition name: (identifier) @class)
    ]]
  )
  local nodes = {}
  ds.ft.treesitter.parse("python", bufnr, function(tree) ---@param tree TSTree
    for id, node in query_tree:iter_captures(tree:root(), bufnr, 0, end_row) do
      local text = vim.treesitter.get_node_text(node, bufnr)
      if query_tree.captures[id] == def then nodes[text] = node end
    end
  end)
  return vim.tbl_keys(nodes)
end

---@param bufnr number
---@param tree TSTree
function M.parse_document(bufnr, tree)
  local query_tree = vim.treesitter.query.parse("python", [[(string_start) @string_init]])
  for id, node, _, _ in query_tree:iter_captures(tree:root()) do
    local name = query_tree.captures[id]
    local text = vim.treesitter.get_node_text(node, bufnr)
    local row_start, col_start, row_end, col_end = node:range()
    if M.render[name] and type(M.render[name]) == "function" then
      M.render[name](
        bufnr,
        NAMESPACE_ID,
        node,
        text,
        { row_start = row_start, col_start = col_start, row_end = row_end, col_end = col_end }
      )
    end
  end
end

---@param bufnr number
---@param clear_buf? boolean
function M.reset_extmarks(bufnr, clear_buf)
  local line = vim.fn.line "."
  if clear_buf then return pcall(vim.api.nvim_buf_clear_namespace, bufnr, NAMESPACE_ID, 0, -1) end
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, NAMESPACE_ID, line - 1, line + 1)
end

---@param bufnr number
function M.set_extmarks(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, NAMESPACE_ID, 0, -1)
  ds.ft.treesitter.parse("python", bufnr, function(tree) M.parse_document(bufnr, tree) end)
end

return M
