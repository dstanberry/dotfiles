---@diagnostic disable: unused-local
---@class ft.markdown.render
local M = {}

---@alias tsRange {row_start: number, col_start: number, row_end?: number, col_end?: number}

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.block_quote_marker = function(bufnr, ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    end_col = range.col_end,
    virt_text = { { ds.icons.misc.VerticalBarBold, "@punctuation.special" } },
    virt_text_pos = "overlay",
  })
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.checkbox_checked = function(bufnr, ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    end_col = range.col_start + #capture_text,
    virt_text = { { ds.pad(ds.icons.markdown.Checked, "right", 2), "@markup.list.checked" } },
    virt_text_pos = "overlay",
  })
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.checkbox_unchecked = function(bufnr, ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    end_col = range.col_start + #capture_text,
    virt_text = { { ds.pad(ds.icons.markdown.Unchecked, "right", 2), "@markup.list.unchecked" } },
    virt_text_pos = "overlay",
  })
end

local calculate_block_width = function(str)
  local width, overflow = 0, 0
  for match in str:gmatch "[%z\1-\127\194-\244][\128-\191]*" do
    overflow = overflow + (vim.fn.strdisplaywidth(match) - 1)
    width = width + #match
  end
  return width, overflow
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.code_span = function(bufnr, ns, capture_node, capture_text, range)
  capture_text = string.gsub(capture_text, "`", "")
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start + 1, {
    virt_text = { { " ", "@markup.raw.markdown_inline" } },
    virt_text_pos = "inline",
  })
  vim.api.nvim_buf_add_highlight(0, ns, "@markup.raw.markdown_inline", range.row_start, range.col_start, range.col_end)
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_end - 1, {
    virt_text = { { " ", "@markup.raw.markdown_inline" } },
    virt_text_pos = "inline",
  })
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.codeblock = function(bufnr, ns, capture_node, capture_text, range)
  local max_width = 0
  local widths = {}
  local lines = vim.tbl_filter(function(s) return not s:find "^```" end, vim.split(capture_text, "\n"))
  for i = 1, (range.row_end - range.row_start) - 2 do
    local line = lines[i]
    local width = vim.fn.strchars(line) or 0
    if width > max_width then max_width = width end
    table.insert(widths, width)
  end
  max_width = math.max(max_width, 78)

  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    virt_text = { { string.rep(" ", max_width + 2), "@markup.codeblock" } },
    virt_text_pos = "inline",
    hl_mode = "combine",
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start, {
    virt_text = { { string.rep(" ", max_width + 2), "@markup.codeblock" } },
    virt_text_pos = "inline",
    hl_mode = "combine",
  })

  for i, line in ipairs(lines) do
    if widths[i] then
      local line_width = widths[i] - range.col_start
      local position, overflow = calculate_block_width(line)
      local col = line_width < 0 and range.col_start + line_width or range.col_start

      vim.api.nvim_buf_add_highlight(0, ns, "@markup.codeblock", range.row_start + i, range.col_start, -1)
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + i, col, {
        virt_text = { { string.rep(" ", 1), "@markup.codeblock" } },
        virt_text_pos = "inline",
      })
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + i, position, {
        virt_text = { { string.rep(" ", max_width - line_width - overflow), "@markup.codeblock" } },
        virt_text_pos = "inline",
      })
    end
  end
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.dash = function(bufnr, ns, capture_node, capture_text, range)
  local parts = {
    { type = "repeat", text = ds.icons.border.CompactRound[2] },
    { type = "text", text = ds.pad(ds.icons.misc.Diamond, "both") },
    { type = "repeat", text = ds.icons.border.CompactRound[2] },
  }
  local content = {}
  for index, part in ipairs(parts) do
    local repeat_amount = part.type == "repeat" and 38 or 1
    for r = 1, repeat_amount do
      table.insert(content, { part.text, "@markup.dash" })
    end
  end
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    end_col = #capture_text,
    virt_text = content,
    virt_text_pos = "overlay",
  })
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.frontmatter = function(bufnr, ns, capture_node, capture_text, range)
  local parts = vim.split(capture_text, "\n")
  if #parts >= 2 then
    local top, bottom = parts[1], parts[#parts]
    vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
      end_col = #top,
      virt_text = { { top, "@comment" } },
      virt_text_pos = "overlay",
      hl_group = "@comment",
    })
    vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start, {
      end_col = #bottom,
      virt_text = { { bottom, "@comment" } },
      virt_text_pos = "overlay",
      hl_group = "@comment",
    })
  end
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.heading = function(bufnr, ns, capture_node, capture_text, range)
  local highlight_groups = { "@markup.heading", "@markup.heading.sub", "@variable.builtin" }
  local headings = {
    ds.icons.markdown.H1,
    ds.icons.markdown.H2,
    ds.icons.markdown.H3,
    ds.icons.markdown.H4,
    ds.icons.markdown.H5,
    ds.icons.markdown.H6,
  }
  local current_heading = headings[#capture_text]
  local current_highlight = highlight_groups[#capture_text] or highlight_groups[#highlight_groups]

  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    end_col = #capture_text,
    virt_text = { { current_heading, current_highlight } },
    virt_text_pos = "overlay",
    hl_group = current_highlight,
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start, {
    virt_text = { { string.rep(ds.icons.border.CompactRound[2], 80), current_highlight } },
    virt_text_pos = "inline",
  })
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.list_marker_minus = function(bufnr, ns, capture_node, capture_text, range)
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
    end_col = range.col_start + #capture_text,
    virt_text = { { ds.icons.markdown.ListMinus, "@markup.list" } },
    virt_text_pos = "overlay",
    hl_group = "@markup.list",
  })
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.md_link = function(bufnr, ns, capture_node, capture_text, range)
  local text = capture_text:match "%[(.-)%]"
  local resource = capture_text:match "%((.-)%)"
  local type = capture_node:type()
  local is_email = type == "email_autolink"
  local icons = {
    image = ds.pad(ds.icons.misc.Image, "right"),
    ["email_autolink"] = ds.pad(ds.icons.misc.User, "right"),
    ["inline_link"] = ds.pad(ds.icons.misc.Link, "right"),
    ["shortcut_link"] = ds.pad(ds.icons.misc.Link, "right"),
  }

  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, is_email and range.col_start or range.col_start + 1, {
    end_col = is_email and range.col_start + 1 or range.col_start,
    virt_text = { { icons[type] or "", "@markup.link" } },
    virt_text_pos = "inline",
    conceal = "",
  })
  vim.api.nvim_buf_add_highlight(bufnr, ns, "@markup.link.label", range.row_start, range.col_start, range.col_end)
  vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end, is_email and range.col_end - 1 or range.col_end, {
    virt_text_pos = "inline",
    virt_text = { { "", "@markup.link" } },
    end_col = is_email and range.col_end or range.col_start,
    conceal = "",
  })
end

local calculate_md_width = function(text)
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

local render_header = function(bufnr, ns, row, alignments, range)
  local current_col, col_offset = 1, 0
  local border = {}
  local prev_extmark = vim.api.nvim_buf_get_extmarks(
    bufnr,
    ns,
    { range.row_start - 1, 0 },
    { range.row_start - 1, 0 },
    {}
  )
  if prev_extmark and type(prev_extmark) == "table" and vim.tbl_count(prev_extmark) > 0 then return end
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRound[1], "@markup.table" })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRound[3], "@markup.table" })
      if range.row_start > 0 then
        vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start - 1, range.col_start, {
          virt_text = border,
          virt_text_pos = "inline",
        })
      end
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.table.Divider[1], "@markup.table" })
      col_offset = col_offset + 1
    else
      local width, real_width = calculate_md_width(col)
      local align = alignments[current_col]
      if width < real_width then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        else
          local before, after = math.floor((real_width - width) / 2), math.ceil((real_width - width) / 2)
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", after) } },
            virt_text_pos = "inline",
          })
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start, range.col_start + col_offset, {
            virt_text = { { string.rep(" ", before) } },
            virt_text_pos = "inline",
          })
        end
      end
      table.insert(border, { string.rep(ds.icons.border.CompactRound[2], real_width), "@markup.table" })
      col_offset = col_offset + vim.fn.strchars(col)
      current_col = current_col + 1
    end
  end
end

local render_delimiter = function(bufnr, ns, row, alignments, range)
  local current_col, col_offset = 1, 0
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.table.Divider[2], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.table.Divider[3], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.table.Divider[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    else
      local align = alignments[current_col]
      if col:match ":" then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start + col_offset, {
            end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
            virt_text = {
              { ds.icons.table.Alignment[1], "@markup.table" },
              { string.rep(ds.icons.border.CompactRound[2], vim.fn.strchars(col) - 1), "@markup.table" },
            },
            virt_text_pos = "inline",
            conceal = "",
          })
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start + col_offset, {
            end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
            virt_text = {
              { string.rep(ds.icons.border.CompactRound[2], vim.fn.strchars(col) - 1), "@markup.table" },
              { ds.icons.table.Alignment[2], "@markup.table" },
            },
            virt_text_pos = "inline",
            conceal = "",
          })
        elseif align == "center" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start + col_offset, {
            end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
            virt_text = {
              { ds.icons.table.Alignment[3], "@markup.table" },
              { string.rep(ds.icons.border.CompactRound[2], vim.fn.strchars(col) - 2), "@markup.table" },
              { ds.icons.table.Alignment[4], "@markup.table" },
            },
            virt_text_pos = "inline",
            conceal = "",
          })
        end
      else
        vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + 1, range.col_start + col_offset, {
          end_col = range.col_start + col_offset + vim.fn.strchars(col) + 1,
          virt_text = { { string.rep(ds.icons.border.CompactRound[2], vim.fn.strchars(col)), "@markup.table" } },
          virt_text_pos = "inline",
          conceal = "",
        })
      end
      col_offset = col_offset + vim.fn.strchars(col)
      current_col = current_col + 1
    end
  end
end

local render_row = function(bufnr, ns, row_num, row, alignments, range)
  local current_col, col_offset = 1, 0
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + row_num - 1, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + row_num - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + row_num - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      col_offset = col_offset + 1
    else
      local width, real_width = calculate_md_width(col)
      local align = alignments[current_col]
      if width < real_width then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(
            bufnr,
            ns,
            range.row_start + row_num - 1,
            range.col_start + col_offset + width + 1,
            {
              virt_text = { { string.rep(" ", (real_width - width)) } },
              virt_text_pos = "inline",
            }
          )
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + row_num - 1, range.col_start, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        else
          local before, after = math.floor((real_width - width) / 2), math.ceil((real_width - width) / 2)
          vim.api.nvim_buf_set_extmark(
            bufnr,
            ns,
            range.row_start + row_num - 1,
            range.col_start + col_offset + width + 1,
            {
              virt_text = { { string.rep(" ", after) } },
              virt_text_pos = "inline",
            }
          )
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_start + row_num - 1, range.col_start + col_offset, {
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

local render_footer = function(bufnr, ns, row, alignments, range)
  local current_col, col_offset = 1, 0
  local border = {}
  for index, col in ipairs(row) do
    if index == 1 then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start, {
        end_col = range.col_start + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRound[7], "@markup.table" })
      col_offset = col_offset + 1
    elseif index == #row then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.border.CompactRound[5], "@markup.table" })
      if range.row_start > 0 then
        vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end, range.col_start, {
          virt_text = border,
          virt_text_pos = "inline",
        })
      end
      col_offset = col_offset + 1
    elseif col == "|" then
      vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start + col_offset, {
        end_col = range.col_start + col_offset + 1,
        virt_text = { { ds.icons.border.CompactRound[4], "@markup.table" } },
        virt_text_pos = "inline",
        conceal = "",
      })
      table.insert(border, { ds.icons.table.Divider[5], "@markup.table" })
      col_offset = col_offset + 1
    else
      local width, real_width = calculate_md_width(col)
      local align = alignments[current_col]
      if width < real_width then
        if align == "left" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        elseif align == "right" then
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start, {
            virt_text = { { string.rep(" ", (real_width - width)) } },
            virt_text_pos = "inline",
          })
        else
          local before, after = math.floor((real_width - width) / 2), math.ceil((real_width - width) / 2)
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start + col_offset + width + 1, {
            virt_text = { { string.rep(" ", after) } },
            virt_text_pos = "inline",
          })
          vim.api.nvim_buf_set_extmark(bufnr, ns, range.row_end - 1, range.col_start + col_offset, {
            virt_text = { { string.rep(" ", before) } },
            virt_text_pos = "inline",
          })
        end
      end
      table.insert(border, { string.rep(ds.icons.border.CompactRound[2], real_width), "@markup.table" })
      col_offset = col_offset + vim.fn.strchars(col)
      current_col = current_col + 1
    end
  end
end

local render_rows = function(bufnr, ns, rows, alignments, range)
  local row_count = 1
  local keys = vim.tbl_keys(rows)
  table.sort(keys, function(a, b) return a < b end)
  for _, index in ipairs(keys) do
    local row = rows[index]
    if row_count == vim.tbl_count(rows) then
      render_footer(bufnr, ns, row, alignments, range)
    else
      render_row(bufnr, ns, index, row, alignments, range)
    end
    row_count = row_count + 1
  end
end

---@param bufnr number
---@param ns number
---@param capture_node TSNode
---@param capture_text string
---@param range tsRange
M.md_table = function(bufnr, ns, capture_node, capture_text, range)
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
      render_header(bufnr, ns, section, alignments, range)
    elseif row:type() == "pipe_table_delimiter_row" then
      render_delimiter(bufnr, ns, section, alignments, range)
    elseif row:type() == "pipe_table_row" then
      rows[row_index] = section
    end
    row_index = row_index + 1
  end
  render_rows(bufnr, ns, rows, alignments, range)
end

return M
