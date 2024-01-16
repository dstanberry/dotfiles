local python_treesitter = require "ft.python.treesitter"

local NAMESPACE_ID = vim.api.nvim_create_namespace "python_conceal"

local M = {}

M.disable = function()
  local line = vim.fn.line "."
  pcall(vim.api.nvim_buf_clear_namespace, 0, NAMESPACE_ID, line - 1, line + 1)
end

M.toggle_on = function()
  vim.api.nvim_buf_clear_namespace(0, NAMESPACE_ID, 0, -1)
  local root, parsed_query = python_treesitter.parse_document()
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
            hl_group = "@macro",
            hl_eol = false,
          })
        end
      end
    end
  end
end

return M
