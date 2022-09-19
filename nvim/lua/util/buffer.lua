local M = {}

function M.create_scratch()
  local ft = vim.fn.input "scratch buffer filetype: "
  vim.cmd.split "20"
  vim.cmd.new "[Scratch]"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false
  if ft then
    vim.bo.filetype = ft
  end
end

function M.delete_buffer(force)
  local buflisted = vim.fn.getbufinfo { buflisted = 1 }
  if #buflisted < 2 then
    vim.cmd.enew()
    return
  end
  local winnr = vim.fn.winnr()
  local bufnr = vim.fn.bufnr()
  for _, winid in ipairs(vim.fn.getbufinfo(bufnr)[1].windows) do
    vim.cmd.wincmd { args = { "w" }, range = { vim.fn.win_id2win(winid) } }
    if bufnr == buflisted[#buflisted].bufnr then
      vim.cmd.bprevious()
    else
      vim.cmd.bnext()
    end
  end
  vim.cmd.wincmd { args = { "w" }, range = { winnr } }
  if force or vim.fn.getbufvar(bufnr, "&buftype") == "terminal" then
    vim.cmd.bdelete { args = { "#" }, bang = true }
  else
    vim.cmd.bdelete { args = { "#" }, mods = { emsg_silent = true, confirm = true } }
  end
end

M.fold_text = function()
  local indent = vim.fn.indent(vim.v.foldstart - 1)
  local indent_level = vim.fn["repeat"](" ", indent)
  local line_count = string.format("%s lines", (vim.v.foldend - vim.v.foldstart + 1))
  local header = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, true)[1]:gsub(" *", "", 1)
  local width = vim.fn.winwidth(0) - vim.wo.foldcolumn - (vim.wo.number and 8 or 0)
  local lhs = string.format("%s%s", indent_level, header)
  local rhs = string.format("%s  · %s", vim.v.foldlevel, line_count)
  local separator = vim.fn["repeat"](" ", width - vim.fn.strwidth(lhs) - vim.fn.strwidth(rhs))
  return string.format("%s %s%s ", lhs, separator, rhs)
end

M.fold_expr = function(lnum)
  if string.find(vim.fn.getline(lnum), "%S") == nil then
    return "-1"
  end
  local get_indent_level = function(n)
    return vim.fn.indent(n) / vim.bo.shiftwidth
  end
  local get_next_line_with_content = function()
    local count = vim.fn.line "$"
    local line = lnum + 1
    while line <= count do
      if string.find(vim.fn.getline(line), "%S") ~= nil then
        return line
      end
      line = line + 1
    end
    return -2
  end
  local current = get_indent_level(lnum)
  local next = get_indent_level(get_next_line_with_content())
  if next <= current then
    return current
  end
  return ">" .. next
end

function M.get_marked_region(mark1, mark2, options)
  local bufnr = 0
  local adjust = options.adjust or function(pos1, pos2)
    return pos1, pos2
  end
  local regtype = options.regtype or vim.fn.visualmode()
  local selection = options.selection or (vim.o.selection ~= "exclusive")
  local pos1 = vim.fn.getpos(mark1)
  local pos2 = vim.fn.getpos(mark2)
  pos1, pos2 = adjust(pos1, pos2)
  local start = { pos1[2] - 1, pos1[3] - 1 + pos1[4] }
  local finish = { pos2[2] - 1, pos2[3] - 1 + pos2[4] }
  if start[2] < 0 or finish[1] < start[1] then
    return
  end
  local region = vim.region(bufnr, start, finish, regtype, selection)
  return region, start, finish
end

function M.get_visual_selection()
  local bufnr = 0
  local visual_modes = {
    v = true,
    V = true,
  }
  if visual_modes[vim.api.nvim_get_mode().mode] == nil then
    return
  end
  local options = {}
  options.adjust = function(pos1, pos2)
    if vim.fn.mode() == "V" then
      pos1[3] = 1
      pos2[3] = 2 ^ 31 - 1
    end
    if pos1[2] > pos2[2] then
      pos2[3], pos1[3] = pos1[3], pos2[3]
      return pos2, pos1
    elseif pos1[2] == pos2[2] and pos1[3] > pos2[3] then
      return pos2, pos1
    else
      return pos1, pos2
    end
  end
  local region, start, finish = M.get_marked_region("v", ".", options)
  if region ~= nil and start ~= nil and finish ~= nil then
    local lines = vim.api.nvim_buf_get_lines(bufnr, start[1], finish[1] + 1, false)
    local line1_end
    if region[start[1]][2] - region[start[1]][1] < 0 then
      line1_end = #lines[1] - region[start[1]][1]
    else
      line1_end = region[start[1]][2] - region[start[1]][1]
    end
    lines[1] = vim.fn.strpart(lines[1], region[start[1]][1], line1_end)
    if start[1] ~= finish[1] then
      lines[#lines] = vim.fn.strpart(lines[#lines], region[finish[1]][1], region[finish[1]][2] - region[finish[1]][1])
    end
    return table.concat(lines)
  end
end

function M.get_syntax_hl_group()
  local win_id = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win_id)
  local stack = vim.fn.synstack(cursor[1], cursor[2])
  dump(vim.tbl_map(function(entry)
    return vim.fn.synIDattr(entry, "name")
  end, stack))
end

return M
