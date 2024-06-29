local M = {}

local NAMESPACE_ID = vim.api.nvim_create_namespace "python_ns_extmarks"

---@param clear_buf? boolean
M.disable_extmarks = function(clear_buf)
  local line = vim.fn.line "."
  if clear_buf then return pcall(vim.api.nvim_buf_clear_namespace, 0, NAMESPACE_ID, 0, -1) end
  pcall(vim.api.nvim_buf_clear_namespace, 0, NAMESPACE_ID, line - 1, line + 1)
end

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

M.set_extmarks = function()
  vim.api.nvim_buf_clear_namespace(0, NAMESPACE_ID, 0, -1)
  local root, parsed_query = M.parse_document()
  for _, captures, metadata in parsed_query:iter_matches(root, 0) do
    for id, node in pairs(captures) do
      local capture = parsed_query.captures[id]
      local start_row, start_column, _, _ =
        unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
      local text = vim.treesitter.get_node_text(node, 0, { concat = true })
      if capture == "string_init" then
        local pre = text:gsub([["]], "")
        if pre == "f" then
          vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, start_column, {
            end_col = start_column + 1,
            hl_group = "@function.macro",
            hl_eol = false,
          })
        end
      end
    end
  end
end

return M
