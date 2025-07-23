---@class ft.html
---@field render ft.html.render
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("ft.html." .. k)
    return rawget(t, k)
  end,
})

local NAMESPACE_ID = vim.api.nvim_create_namespace "ds_html_extmarks"

---@param bufnr number
---@param callback function
local traverse_tree = function(bufnr, callback)
  local root_parser = vim.treesitter.get_parser(bufnr)
  if not root_parser then return end
  root_parser:parse(true)
  root_parser:for_each_tree(function(TStree, language_tree)
    local tree_language = language_tree:lang()
    if tree_language == "html" then callback(TStree) end
  end)
end

---@param bufnr number
---@param tree TSTree
M.parse_document = function(bufnr, tree)
  local query_tree = vim.treesitter.query.parse(
    "html",
    [[
      (attribute
        (attribute_name) @attr_name
          (quoted_attribute_value (attribute_value) @class_values)
      )
    ]]
  )
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
M.reset_extmarks = function(bufnr, clear_buf)
  local line = vim.fn.line "."
  if clear_buf then return pcall(vim.api.nvim_buf_clear_namespace, bufnr, NAMESPACE_ID, 0, -1) end
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, NAMESPACE_ID, line - 1, line + 1)
end

---@param bufnr number
M.set_extmarks = function(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, NAMESPACE_ID, 0, -1)
  traverse_tree(bufnr, function(tree) M.parse_document(bufnr, tree) end)
end

return M
