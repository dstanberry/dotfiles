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
}

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
          vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, 0, {
            end_col = #top,
            virt_text = { { top, "@comment" } },
            virt_text_pos = "overlay",
            hl_group = "@comment",
          })
          vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, end_row - 1, 0, {
            end_col = #bottom,
            virt_text = { { bottom, "@comment" } },
            virt_text_pos = "overlay",
            hl_group = "@comment",
          })
        end
      elseif capture == "heading_marker" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, 0, {
          end_col = #text,
          virt_text = { { headings[#text], highlight_groups[#text] or highlight_groups[#highlight_groups] } },
          virt_text_pos = "overlay",
          hl_group = highlight_groups[#text] or highlight_groups[#highlight_groups],
        })
      elseif capture == "checkbox_unchecked" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, start_column, {
          end_col = start_column + #text,
          virt_text = { { icons.markdown.Unchecked, "@text.todo" } },
          virt_text_pos = "overlay",
          hl_group = "@text.todo",
        })
      elseif capture == "checkbox_checked" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, start_column, {
          end_col = start_column + #text,
          virt_text = { { icons.markdown.Checked, "@text.todo" } },
          virt_text_pos = "overlay",
          hl_group = "@text.todo",
        })
      elseif capture == "list_marker_minus" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, start_column, {
          end_col = start_column + #text,
          virt_text = { { icons.markdown.ListMinus, "@punctuation.special" } },
          virt_text_pos = "overlay",
          hl_group = "@punctuation.special",
        })
      elseif capture == "dash" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, 0, {
          virt_text = { { ("-"):rep(vim.api.nvim_win_get_width(0)), "@text.dash" } },
          virt_text_pos = "overlay",
          hl_group = "combine",
        })
      elseif capture == "codeblock" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, 0, {
          end_col = 0,
          end_row = end_row,
          hl_group = "@text.codeblock",
          hl_eol = true,
        })
      end
    end
  end
end

return M
