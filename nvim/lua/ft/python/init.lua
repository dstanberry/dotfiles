local M = {}

M.parse_document = function()
  local language_tree = vim.treesitter.get_parser(0, "python")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local parsed_query = vim.treesitter.query.parse(
    "python",
    [[
      (string_start) @string_init
    ]]
  )
  return root, parsed_query
end

local NAMESPACE_ID = vim.api.nvim_create_namespace "ds_python_extmarks"

---@param clear_buf? boolean
M.disable_extmarks = function(clear_buf)
  local line = vim.fn.line "."
  if clear_buf then return pcall(vim.api.nvim_buf_clear_namespace, 0, NAMESPACE_ID, 0, -1) end
  pcall(vim.api.nvim_buf_clear_namespace, 0, NAMESPACE_ID, line - 1, line + 1)
end

M.set_extmarks = function()
  vim.api.nvim_buf_clear_namespace(0, NAMESPACE_ID, 0, -1)
  local root, parsed_query = M.parse_document()
  for capture_id, capture_node, _, _ in parsed_query:iter_captures(root, 0) do
    local capture_name = parsed_query.captures[capture_id]
    local row_start, col_start, _, _ = capture_node:range()
    local capture_text = vim.treesitter.get_node_text(capture_node, 0)
    if capture_name == "string_init" then
      local pre = capture_text:gsub([["]], "")
      if pre == "f" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, row_start, col_start, {
          end_col = col_start + 1,
          hl_group = "@function.macro",
          hl_eol = false,
        })
      end
    end
  end
end

return M
