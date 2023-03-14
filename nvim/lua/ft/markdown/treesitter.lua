local M = {}

M.parse_document = function()
  local language_tree = vim.treesitter.get_parser(0, "markdown")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  ---@diagnostic disable-next-line: undefined-field
  local parsed_query = vim.treesitter.parse_query(
    "markdown",
    [[
      ([
        (minus_metadata)
        (plus_metadata)
      ] @yaml_frontmatter)
      (atx_heading [
        (atx_h1_marker)
        (atx_h2_marker)
        (atx_h3_marker)
        (atx_h4_marker)
        (atx_h5_marker)
        (atx_h6_marker)
      ] @heading_marker)
      (list_marker_minus) @list_marker_minus
      (task_list_marker_unchecked) @checkbox_unchecked
      (task_list_marker_checked) @checkbox_checked
    ]]
  )
  return root, parsed_query
end

return M
