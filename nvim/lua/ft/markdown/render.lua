---@diagnostic disable: unused-local
---@class ft.markdown.render
local M = {}

---@alias tsRange {row_start: number, col_start: number, row_end?: number, col_end?: number}

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.checkbox_checked = function(ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start, {
    end_col = range.col_start + #capture_text,
    virt_text = { { ds.icons.markdown.Checked, "@markup.todo" } },
    virt_text_pos = "overlay",
    hl_group = "@markup.todo",
  })
end

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.checkbox_unchecked = function(ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start, {
    end_col = range.col_start + #capture_text,
    virt_text = { { ds.icons.markdown.Unchecked, "@markup.todo" } },
    virt_text_pos = "overlay",
    hl_group = "@markup.todo",
  })
end

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.codeblock = function(ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(0, ns, range.row_start, 0, {
    end_col = 0,
    end_row = range.row_end,
    hl_group = "@markup.codeblock",
    hl_eol = true,
  })
end

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.dash = function(ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(0, ns, range.row_start, 0, {
    virt_text = { { ("-"):rep(vim.api.nvim_win_get_width(0)), "@markup.dash" } },
    virt_text_pos = "overlay",
    hl_group = "combine",
  })
end

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.frontmatter = function(ns, capture_node, capture_text, range)
  local parts = vim.split(capture_text, "\n")
  if #parts >= 2 then
    local top, bottom = parts[1], parts[#parts]
    vim.api.nvim_buf_set_extmark(0, ns, range.row_start, 0, {
      end_col = #top,
      virt_text = { { top, "@comment" } },
      virt_text_pos = "overlay",
      hl_group = "@comment",
    })
    vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, 0, {
      end_col = #bottom,
      virt_text = { { bottom, "@comment" } },
      virt_text_pos = "overlay",
      hl_group = "@comment",
    })
  end
end

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.heading = function(ns, capture_node, capture_text, range)
  local highlight_groups = { "@markup.heading", "@markup.heading", "@variable.builtin" }
  local headings = {
    ds.icons.markdown.H1,
    ds.icons.markdown.H2,
    ds.icons.markdown.H3,
    ds.icons.markdown.H4,
    ds.icons.markdown.H5,
    ds.icons.markdown.H6,
  }

  vim.api.nvim_buf_set_extmark(0, ns, range.row_start, 0, {
    end_col = #capture_text,
    virt_text = {
      { headings[#capture_text], highlight_groups[#capture_text] or highlight_groups[#highlight_groups] },
    },
    virt_text_pos = "overlay",
    hl_group = highlight_groups[#capture_text] or highlight_groups[#highlight_groups],
  })
end

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.list_marker_minus = function(ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start, {
    end_col = range.col_start + #capture_text,
    virt_text = { { ds.icons.markdown.ListMinus, "@markup.list" } },
    virt_text_pos = "overlay",
    hl_group = "@markup.list",
  })
end

local calculate_width = function(text)
  local width = vim.fn.strchars(text)
  for fmt_start, fmt_end in text:gmatch "([*_]*)%w+([*_]*)" do
    local pre = text:sub(text:find(fmt_start .. "%w+" .. fmt_end) - 1, text:find(fmt_start .. "%w+" .. fmt_end) - 1)
    if pre ~= "[" and pre ~= "`" then
      local min_signs = math.min(vim.fn.strchars(fmt_start), vim.fn.strchars(fmt_end))
      width = width - (2 * min_signs)
    end
  end
  return width, vim.fn.strchars(text)
end

local determine_alignment = function(text)
  local first_char = text:sub(0, 1)
  local last_char = text:sub(#text, -1)
  if text:match ":" == nil then
    return "left"
  elseif first_char == ":" and last_char == ":" then
    return "center"
  elseif first_char == ":" then
    return "left"
  elseif last_char == ":" then
    return "right"
  end
  return ""
end

local render_header = function(ns, row, alignments, range)
  local current_col, col_offset = 1, 0
  local border = {}
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRounded[1], "@markup.table" })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRounded[3], "@markup.table" })
      if range.row_start > 0 then
        vim.api.nvim_buf_set_extmark(0, ns, range.row_start - 1, range.col_start, {
          virt_text = border,
          virt_text_pos = "inline",
        })
      end
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.table.Dividers[1], "@markup.table" })
      col_offset = col_offset + 1
    else
      local width, real_width = calculate_width(col)
      local align = alignments[current_col]
      if width < real_width then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        else
          local before, after = math.floor((real_width - width) / 2), math.ceil((real_width - width) / 2)
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", after) } },
            virt_text_pos = "inline",
          })
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start, range.col_start + col_offset, {
            virt_text = { { string.rep(" ", before) } },
            virt_text_pos = "inline",
          })
        end
      end
      table.insert(border, { string.rep(ds.icons.border.CompactRounded[2], real_width), "@markup.table" })
      col_offset = col_offset + vim.fn.strchars(col)
      current_col = current_col + 1
    end
  end
end

local render_delimiter = function(ns, row, alignments, range)
  local current_col, col_offset = 1, 0
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start + 1, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.table.Dividers[2], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start + 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.table.Dividers[3], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start + 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.table.Dividers[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    else
      local align = alignments[current_col]
      if col:match ":" then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start + 1, range.col_start + col_offset, {
            end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
            virt_text = {
              { ds.icons.table.Alignment[1], "@markup.table" },
              { string.rep(ds.icons.border.CompactRounded[2], vim.fn.strchars(col) - 1), "@markup.table" },
            },
            virt_text_pos = "inline",
            conceal = "",
          })
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start + 1, range.col_start + col_offset, {
            end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
            virt_text = {
              { string.rep(ds.icons.border.CompactRounded[2], vim.fn.strchars(col) - 1), "@markup.table" },
              { ds.icons.table.Alignment[2], "@markup.table" },
            },
            virt_text_pos = "inline",
            conceal = "",
          })
        elseif align == "center" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start + 1, range.col_start + col_offset, {
            end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
            virt_text = {
              { ds.icons.table.Alignment[3], "@markup.table" },
              { string.rep(ds.icons.border.CompactRounded[2], vim.fn.strchars(col) - 2), "@markup.table" },
              { ds.icons.table.Alignment[4], "@markup.table" },
            },
            virt_text_pos = "inline",
            conceal = "",
          })
        end
      else
        vim.api.nvim_buf_set_extmark(0, ns, range.row_start + 1, range.col_start + col_offset, {
          end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
          virt_text = { { string.rep(ds.icons.border.CompactRounded[2], vim.fn.strchars(col)), "@markup.table" } },
          virt_text_pos = "inline",
          conceal = "",
        })
      end
      col_offset = col_offset + vim.fn.strchars(col)
      current_col = current_col + 1
    end
  end
end

local render_row = function(ns, row_num, row, alignments, range)
  local current_col, col_offset = 1, 0
  -- ds.info { row_num, range.row_start, range.row_end, row }
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start + row_num - 1, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start + row_num - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_start + row_num - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    else
      local width, real_width = calculate_width(col)
      local align = alignments[current_col]
      if width < real_width then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start + row_num - 1, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start + row_num - 1, range.col_start, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        else
          local before, after = math.floor((real_width - width) / 2), math.ceil((real_width - width) / 2)
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start + row_num - 1, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", after) } },
            virt_text_pos = "inline",
          })
          vim.api.nvim_buf_set_extmark(0, ns, range.row_start + row_num - 1, range.col_start + col_offset, {
            virt_text = { { string.rep(" ", before) } },
            virt_text_pos = "inline",
          })
        end
      end
      col_offset = col_offset + vim.fn.strchars(col)
      current_col = current_col + 1
    end
  end
end

local render_footer = function(ns, row, alignments, range)
  local current_col, col_offset = 1, 0
  local border = {}
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRounded[7], "@markup.table" })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRounded[5], "@markup.table" })
      if range.row_start > 0 then
        vim.api.nvim_buf_set_extmark(0, ns, range.row_end, range.col_start, {
          virt_text = border,
          virt_text_pos = "inline",
        })
      end
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRounded[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.table.Dividers[5], "@markup.table" })
      col_offset = col_offset + 1
    else
      local width, real_width = calculate_width(col)
      local align = alignments[current_col]
      if width < real_width then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, range.col_start, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        else
          local before, after = math.floor((real_width - width) / 2), math.ceil((real_width - width) / 2)
          vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", after) } },
            virt_text_pos = "inline",
          })
          vim.api.nvim_buf_set_extmark(0, ns, range.row_end - 1, range.col_start + col_offset, {
            virt_text = { { string.rep(" ", before) } },
            virt_text_pos = "inline",
          })
        end
      end
      table.insert(border, { string.rep(ds.icons.border.CompactRounded[2], real_width), "@markup.table" })
      col_offset = col_offset + vim.fn.strchars(col)
      current_col = current_col + 1
    end
  end
end

local render_rows = function(ns, rows, alignments, range)
  local row_count = 1
  local keys = vim.tbl_keys(rows)
  table.sort(keys, function(a, b) return a < b end)
  for _, index in ipairs(keys) do
    local row = rows[index]
    if row_count == vim.tbl_count(rows) then
      render_footer(ns, row, alignments, range)
    else
      render_row(ns, index, row, alignments, range)
    end
    row_count = row_count + 1
  end
end

---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.table = function(ns, capture_node, capture_text, range)
  local parts = vim.split(capture_text, "\n")
  local delimiter, alignments, rows = {}, {}, {}
  local row_index = 1
  for _, s in ipairs(vim.split(parts[2], "|")) do
    s = vim.trim(s)
    if s ~= "" then table.insert(delimiter, s) end
  end
  for _, text in ipairs(delimiter) do
    table.insert(alignments, determine_alignment(text))
  end
  for row in capture_node:iter_children() do
    local row_type = row:type()
    local curr_tbl_col, curr_col = 1, 0
    local section = {}

    for col in vim.treesitter.get_node_text(row, 0):gmatch "%s*|([^|\n]*)" do
      if col ~= "" then
        table.insert(section, "|")
        table.insert(section, col)
      end
    end
    table.insert(section, "|")

    rows[row_index] = nil
    if row_type == "pipe_table_header" then
      render_header(ns, section, alignments, range)
    elseif row:type() == "pipe_table_delimiter_row" then
      render_delimiter(ns, section, alignments, range)
    elseif row:type() == "pipe_table_row" then
      rows[row_index] = section
    end
    row_index = row_index + 1
  end
  render_rows(ns, rows, alignments, range)
end

return M
