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

return M
