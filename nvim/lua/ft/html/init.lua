---@class ft.html
---@field render ft.html.render
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require(string.format("ft.html.%s", k))
    return t[k]
  end,
})

local NAMESPACE_ID = vim.api.nvim_create_namespace "ds_html_extmarks"

local Q = vim.treesitter.query.parse(
  "html",
  [[
    ((attribute
        (attribute_name) @att_name (#eq? @att_name "class")
        (quoted_attribute_value (attribute_value) @class_value) @class_values))
  ]]
)

---@param bufnr number
---@param tree TSTree
M.parse_document = function(bufnr, tree)
  for capture_id, capture_node, _, _ in Q:iter_captures(tree:root()) do
    local capture_name = Q.captures[capture_id]
    local capture_text = vim.treesitter.get_node_text(capture_node, bufnr)
    local row_start, col_start, row_end, col_end = capture_node:range()
    if M.render[capture_name] and type(M.render[capture_name]) == "function" then
      M.render[capture_name](
        bufnr,
        NAMESPACE_ID,
        capture_node,
        capture_text,
        { row_start = row_start, col_start = col_start, row_end = row_end, col_end = col_end }
      )
    end
  end
end

---@param bufnr number
---@param clear_buf? boolean
M.disable_extmarks = function(bufnr, clear_buf)
  local line = vim.fn.line "."
  if clear_buf then return pcall(vim.api.nvim_buf_clear_namespace, bufnr, NAMESPACE_ID, 0, -1) end
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, NAMESPACE_ID, line - 1, line + 1)
end

---@param bufnr number
M.set_extmarks = function(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, NAMESPACE_ID, 0, -1)

  local root_parser = vim.treesitter.get_parser(bufnr)
  root_parser:parse(true)
  root_parser:for_each_tree(function(TStree, language_tree)
    local tree_language = language_tree:lang()
    if tree_language == "html" then M.parse_document(bufnr, TStree) end
  end)
end

return M
