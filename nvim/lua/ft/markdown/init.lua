---@class ft.markdown
---@field render ft.markdown.render
---@field zk ft.markdown.zk
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("ft.markdown." .. k)
    return rawget(t, k)
  end,
})

local NAMESPACE_ID = vim.api.nvim_create_namespace "ds_markdown_extmarks"

local MD_Q = vim.treesitter.query.parse(
  "markdown",
  [[
      ([
        (minus_metadata)
        (plus_metadata)
      ] @frontmatter)
      (atx_heading [
        (atx_h1_marker)
        (atx_h2_marker)
        (atx_h3_marker)
        (atx_h4_marker)
        (atx_h5_marker)
        (atx_h6_marker)
      ] @heading)
      (block_quote [
        (block_quote_marker)
        (block_continuation)
      ] @block_quote_marker)
      (inline (block_continuation) @block_quote_marker)
      (paragraph (block_continuation) @block_quote_marker)
      ((fenced_code_block) @codeblock)
      ((list_marker_dot) @list_marker_dot)
      ((list_marker_minus) @list_marker_minus)
      ((pipe_table) @md_table)
      ((task_list_marker_checked) @checkbox_checked)
      ((task_list_marker_unchecked) @checkbox_unchecked)
      ((thematic_break) @dash)
    ]]
)

local MD_INLINE_Q = vim.treesitter.query.parse(
  "markdown_inline",
  [[
      ([
        (email_autolink)
        (image)
        (inline_link)
        (shortcut_link)
      ] @md_link)
      ((code_span) @code_span)
    ]]
)

M.insert_checkbox = function() vim.api.nvim_put({ "[ ] " }, "c", true, true) end

M.insert_link = function()
  local url = vim.fn.getreg "*"
  local link = string.format("[](%s)", url)
  local cursor = vim.fn.getpos "."
  vim.api.nvim_put({ link }, "c", true, true)
  vim.fn.setpos(".", { cursor[1], cursor[2], cursor[3] + 1, cursor[4] })
end

M.insert_list_marker = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local capture_node = vim.treesitter.get_node { bufnr = 0, pos = { cursor[1] - 1, 0 } }
  if capture_node then
    local capture_name = capture_node:type()
    local capture_text = vim.treesitter.get_node_text(capture_node, 0)
    local newtext = ""

    if capture_name == "checkbox_unchecked" or capture_name == "checkbox_checked" then
      newtext = "[ ] "
    elseif capture_name == "list_marker_dot" then
      local next = tonumber(capture_text:sub(1, 1))
      if next and type(next) == "number" then newtext = ("%s. "):format(next + 1) end
    elseif capture_name == "list_marker_minus" then
      newtext = ("%s "):format(capture_text:sub(1, 1))
    end
    vim.api.nvim_buf_set_lines(0, cursor[1], cursor[1], false, { newtext })
    vim.api.nvim_win_set_cursor(0, { cursor[1] + 1, #newtext + 1 })
  end
end

---@param bufnr number
local get_all_headings = function(bufnr)
  local data = {}
  local root
  local root_parser = vim.treesitter.get_parser(bufnr)
  root_parser:parse(true)
  root_parser:for_each_tree(function(TStree, language_tree)
    local tree_language = language_tree:lang()
    if tree_language == "markdown" then root = TStree:root() end
  end)
  if root then
    for capture_id, capture_node, _, _ in MD_Q:iter_captures(root, 0) do
      local capture_name = MD_Q.captures[capture_id]
      local row_start, _, row_end, _ = capture_node:range()
      local capture_text = vim.treesitter.get_node_text(capture_node, 0)
      if capture_name == "heading" then
        local hold = {
          start_row = row_start,
          end_row = row_end,
          level = #capture_text,
          index = #data + 1,
        }
        table.insert(data, hold)
      elseif capture_name == "frontmatter" then
        local hold = {
          start_row = row_start,
          end_row = row_end,
          level = 1,
          index = #data + 1,
        }
        table.insert(data, hold)
      end
    end
  end
  return data
end

local get_previous_heading = function(data)
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local previous = data[1] or { level = 0, index = 0 }
  for i = 1, #data do
    if data[i].start_row > current_pos[1] then return previous end
    previous = data[i]
  end
  return previous
end

local insert_heading = function(data, previous_heading, text)
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

---@param bufnr number
M.insert_adjacent_heading = function(bufnr)
  local data = get_all_headings(bufnr)
  local previous_heading = get_previous_heading(data)
  previous_heading.level = math.max(previous_heading.level, 2)
  local text_ready = string.rep("#", previous_heading.level) .. " "
  insert_heading(data, previous_heading, text_ready)
end

---@param bufnr number
M.insert_inner_heading = function(bufnr)
  local data = get_all_headings(bufnr)
  local previous_heading = get_previous_heading(data)
  previous_heading.level = math.max(previous_heading.level, 1)
  previous_heading.level = math.min(previous_heading.level, 5)
  local text_ready = string.rep("#", previous_heading.level + 1) .. " "
  insert_heading(data, previous_heading, text_ready)
end

---@param bufnr number
M.insert_outer_heading = function(bufnr)
  local data = get_all_headings(bufnr)
  local previous_heading = get_previous_heading(data)
  previous_heading.level = math.max(previous_heading.level, 3)
  previous_heading.level = math.min(previous_heading.level, 7)
  local text_ready = string.rep("#", previous_heading.level - 1) .. " "
  insert_heading(data, previous_heading, text_ready)
end

local get_lines = function()
  local line_start, line_end
  if vim.fn.getpos("'<")[2] == vim.fn.getcurpos()[2] and vim.fn.getpos("'<")[3] == vim.fn.getcurpos()[3] then
    line_start = vim.fn.getpos("'<")[2]
    line_end = vim.fn.getpos("'>")[2]
  else
    line_start = vim.fn.getcurpos()[2]
    line_end = vim.fn.getcurpos()[2]
  end
  return line_start, line_end, vim.fn.getline(line_start, line_end)
end

M.toggle_bullet = function()
  local newlines = {}
  local line_start, line_end, lines = get_lines()
  for _, line in ipairs(lines) do
    if string.match(line, "^%s*%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1")))
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
  M.set_extmarks()
end

M.toggle_checkbox = function()
  local newlines = {}
  local line_start, line_end, lines = get_lines()
  for _, line in ipairs(lines) do
    if string.match(line, "^(%s*)%-%s%[%s%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[%s%]%s", "%1- [x] ")))
    elseif string.match(line, "^(%s*)%-%s%[x%]%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s%[x%]%s", "%1- ")))
    elseif string.match(line, "^(%s*)%-%s") then
      table.insert(newlines, (string.gsub(line, "^(%s*)%-%s", "%1- [ ] ")))
    else
      table.insert(newlines, (string.gsub(line, "^(%s*)", "%1- [ ] ")))
    end
  end
  if line_start == line_end then
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  else
    vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, true, newlines)
  end
  M.set_extmarks()
end

---@param bufnr number
---@param tree TSTree
M.parse_md = function(bufnr, tree)
  for capture_id, capture_node, _, _ in MD_Q:iter_captures(tree:root()) do
    local capture_name = MD_Q.captures[capture_id]
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
---@param tree TSTree
M.parse_md_inline = function(bufnr, tree)
  for capture_id, capture_node, _, _ in MD_INLINE_Q:iter_captures(tree:root()) do
    local capture_name = MD_INLINE_Q.captures[capture_id]
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
  if root_parser then
    root_parser:parse(true)
    root_parser:for_each_tree(function(TStree, language_tree)
      local tree_language = language_tree:lang()
      if tree_language == "markdown" then
        M.parse_md(bufnr, TStree)
      elseif tree_language == "markdown_inline" then
        M.parse_md_inline(bufnr, TStree)
      end
    end)
  end
end

return M
