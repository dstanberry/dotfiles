local treesitter_query = require "vim.treesitter.query"
local markdown_treesitter = require "ft.markdown.treesitter"

local M = {}

local get_all_headings = function()
  local data = {}
  local root, parsed_query = markdown_treesitter.parse_document()
  for _, captures, metadata in parsed_query:iter_matches(root, 0, 0, 0) do
    for id, node in pairs(captures) do
      local capture = parsed_query.captures[id]
      local start_row, _, end_row, _ =
        unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
      if capture == "heading_marker" then
        local hold = {
          start_row = start_row,
          end_row = end_row,
          level = #treesitter_query.get_node_text(node, 0),
          index = #data + 1,
        }
        table.insert(data, hold)
      elseif capture == "yaml_frontmatter" then
        local hold = {
          start_row = start_row,
          end_row = end_row,
          level = 1,
          index = #data + 1,
        }
        table.insert(data, hold)
      end
    end
  end
  return data
end

local get_previous_header = function(data)
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local previous = vim.F.if_nil(data[1], { level = 0, index = 0 })
  for i = 1, #data do
    if data[i].start_row > current_pos[1] then return previous end
    previous = data[i]
  end
  return previous
end

local insert_header = function(data, previous_heading, text)
  local target_row, target_end, cursor_target
  if previous_heading.index ~= #data then
    target_row = data[previous_heading.index + 1].start_row
    target_end = target_row
    cursor_target = target_row + 1
  else
    target_row = -2
    target_end = -1
    cursor_target = vim.api.nvim_buf_line_count(0)
  end
  vim.api.nvim_buf_set_lines(0, target_row, target_end, false, { text })
  vim.api.nvim_win_set_cursor(0, { cursor_target, #text + 1 })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A", true, true, true), "n", true)
end

M.insert_adjacent = function()
  local data = get_all_headings()
  local previous_heading = get_previous_header(data)
  previous_heading.level = math.max(previous_heading.level, 2)
  local text_ready = string.rep("#", previous_heading.level) .. " "
  insert_header(data, previous_heading, text_ready)
end

M.insert_inner = function()
  local data = get_all_headings()
  local previous_heading = get_previous_header(data)
  previous_heading.level = math.max(previous_heading.level, 1)
  previous_heading.level = math.min(previous_heading.level, 5)
  local text_ready = string.rep("#", previous_heading.level + 1) .. " "
  insert_header(data, previous_heading, text_ready)
end

M.insert_outer = function()
  local data = get_all_headings()
  local previous_heading = get_previous_header(data)
  previous_heading.level = math.max(previous_heading.level, 3)
  previous_heading.level = math.min(previous_heading.level, 7)
  local text_ready = string.rep("#", previous_heading.level - 1) .. " "
  insert_header(data, previous_heading, text_ready)
end

return M
