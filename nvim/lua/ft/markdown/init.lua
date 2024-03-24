local icons = require "ui.icons"

local M = {
  zk = require "ft.markdown.zk",
}

local NAMESPACE_ID = vim.api.nvim_create_namespace "markdown_ns_extmarks"

local headings = {
  icons.markdown.H1,
  icons.markdown.H2,
  icons.markdown.H3,
  icons.markdown.H4,
  icons.markdown.H5,
  icons.markdown.H6,
}

local highlight_groups = {
  "@markup.heading",
  "@markup.heading",
  "@variable.builtin",
}

M.disable_extmarks = function()
  local line = vim.fn.line "."
  pcall(vim.api.nvim_buf_clear_namespace, 0, NAMESPACE_ID, line - 1, line + 1)
end

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
  local node = vim.treesitter.get_node { bufnr = 0, pos = { cursor[1] - 1, 0 } }
  if node then
    local capture = node:type()
    local text = vim.treesitter.get_node_text(node, 0)
    local newtext = ""

    if capture == "checkbox_unchecked" or capture == "checkbox_checked" then
      newtext = "[ ] "
    elseif capture == "list_marker_dot" then
      local next = tonumber(text:sub(1, 1))
      if next and type(next) == "number" then newtext = ("%s. "):format(next + 1) end
    elseif capture == "list_marker_minus" then
      newtext = ("%s "):format(text:sub(1, 1))
    end
    vim.api.nvim_buf_set_lines(0, cursor[1], cursor[1], false, { newtext })
    vim.api.nvim_win_set_cursor(0, { cursor[1] + 1, #newtext + 1 })
  end
end

local get_all_headings = function()
  local data = {}
  local root, parsed_query = M.parse_document()
  for _, captures, metadata in parsed_query:iter_matches(root, 0, 0, 0) do
    for id, node in pairs(captures) do
      local capture = parsed_query.captures[id]
      local start_row, _, end_row, _ =
        unpack(vim.tbl_extend("force", { node:range() }, (metadata[id] or {}).range or {}))
      if capture == "heading_marker" then
        local hold = {
          start_row = start_row,
          end_row = end_row,
          level = #vim.treesitter.get_node_text(node, 0),
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

local get_previous_heading = function(data)
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local previous = vim.F.if_nil(data[1], { level = 0, index = 0 })
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

M.insert_adjacent_heading = function()
  local data = get_all_headings()
  local previous_heading = get_previous_heading(data)
  previous_heading.level = math.max(previous_heading.level, 2)
  local text_ready = string.rep("#", previous_heading.level) .. " "
  insert_heading(data, previous_heading, text_ready)
end

M.insert_inner_heading = function()
  local data = get_all_headings()
  local previous_heading = get_previous_heading(data)
  previous_heading.level = math.max(previous_heading.level, 1)
  previous_heading.level = math.min(previous_heading.level, 5)
  local text_ready = string.rep("#", previous_heading.level + 1) .. " "
  insert_heading(data, previous_heading, text_ready)
end

M.insert_outer_heading = function()
  local data = get_all_headings()
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
  M.buf.set_extmarks()
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
  M.buf.set_extmarks()
end

M.parse_document = function()
  local language_tree = vim.treesitter.get_parser(0, "markdown")
  local syntax_tree = language_tree:parse()
  local root = syntax_tree[1]:root()
  local parsed_query = vim.treesitter.query.parse(
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
      (list_marker_dot) @list_marker_dot
      (list_marker_minus) @list_marker_minus
      (task_list_marker_unchecked) @checkbox_unchecked
      (task_list_marker_checked) @checkbox_checked
      (thematic_break) @dash
      (fenced_code_block) @codeblock
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
          virt_text = { { icons.markdown.Unchecked, "@markup.todo" } },
          virt_text_pos = "overlay",
          hl_group = "@markup.todo",
        })
      elseif capture == "checkbox_checked" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, start_column, {
          end_col = start_column + #text,
          virt_text = { { icons.markdown.Checked, "@markup.todo" } },
          virt_text_pos = "overlay",
          hl_group = "@markup.todo",
        })
      elseif capture == "list_marker_minus" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, start_column, {
          end_col = start_column + #text,
          virt_text = { { icons.markdown.ListMinus, "@markup.list" } },
          virt_text_pos = "overlay",
          hl_group = "@markup.list",
        })
      elseif capture == "dash" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, 0, {
          virt_text = { { ("-"):rep(vim.api.nvim_win_get_width(0)), "@markup.dash" } },
          virt_text_pos = "overlay",
          hl_group = "combine",
        })
      elseif capture == "codeblock" then
        vim.api.nvim_buf_set_extmark(0, NAMESPACE_ID, start_row, 0, {
          end_col = 0,
          end_row = end_row,
          hl_group = "@markup.codeblock",
          hl_eol = true,
        })
      end
    end
  end
end

return M
