local markdown_treesitter = require "ft.markdown.treesitter"
local icons = require "ui.icons"

local NAMESPACE_ID = vim.api.nvim_create_namespace "markdown_conceal"

local M = {}

local headings = {
  icons.markdown.H1,
  icons.markdown.H2,
  icons.markdown.H3,
  icons.markdown.H4,
  icons.markdown.H5,
  icons.markdown.H6,
}

local highlight_groups = {
  "@text.title",
  "@text.heading",
  "@variable.builtin",
  "@variable.builtin",
  "@variable.builtin",
  "@variable.builtin",
}

local set_extmark = function(start_row, end_row, start_col, end_col, hl_group, text)
  start_col = start_col or 0
  -- NOTE: custom markdown treesitter query covers this
  -- vim.api.nvim_buf_set_extmark(0, NAMESPACE, start_row, 0, {
  --   end_row = end_row + 1,
  --   hl_group = hl_group,
  -- })
  vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, start_col, {
    end_col = end_col,
    virt_text = { { text, hl_group } },
    virt_text_pos = "overlay",
    hl_group = hl_group,
  })
end

M.disable = function()
  local line = vim.fn.line "."
  pcall(vim.api.nvim_buf_clear_namespace, 0, NAMESPACE_ID, line - 1, line + 1)
end

M.toggle_on = function()
  vim.api.nvim_buf_clear_namespace(0, NAMESPACE_ID, 0, -1)
  local root, parsed_query = markdown_treesitter.parse_document()
  for _, captures, metadata in parsed_query:iter_matches(root, 0) do
    for id, node in pairs(captures) do
      local capture = parsed_query.captures[id]
      local start_row, start_column, end_row, _ =
        unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
      local text = vim.treesitter.get_node_text(node, 0, { concat = true })
      if capture == "yaml_frontmatter" then
        local parts = vim.split(text, "\n")
        if #parts >= 2 then
          local top, bottom = parts[1], parts[#parts]
          set_extmark(start_row, start_row, 0, #top, "@comment", top)
          set_extmark(end_row - 1, end_row - 1, 0, #bottom, "@comment", bottom)
        end
      elseif capture == "heading_marker" then
        set_extmark(start_row, end_row, 0, #text, highlight_groups[#text], headings[#text])
      elseif capture == "checkbox_unchecked" then
        set_extmark(start_row, end_row, start_column, start_column + #text, "@text.todo", icons.markdown.Unchecked)
      elseif capture == "checkbox_checked" then
        set_extmark(start_row, end_row, start_column, start_column + #text, "@text.todo", icons.markdown.Checked)
      elseif capture == "list_marker_minus" then
        set_extmark(
          start_row,
          end_row,
          start_column,
          start_column + #text,
          "@punctuation.special",
          icons.markdown.ListMinus
        )
      end
    end
  end
end

return M
