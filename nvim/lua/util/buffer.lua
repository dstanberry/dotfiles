local M = {}

function M.create_scratch_buffer()
  local ft = vim.fn.input "scratch buffer filetype: "
  vim.cmd "20new [Scratch]"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.buftype = "nofile"
  vim.bo.swapfile = false
  if ft then
    vim.bo.filetype = ft
  end
end

function M.create_md_note()
  local dir = vim.env.hash_n or vim.env.HOME
  local fname = ("%s/%s.md"):format(dir, os.date "%m_%d_%y")
  vim.cmd(("edit %s"):format(fname))
  local bufnr = vim.fn.bufnr(vim.fn.expand(("%s"):format(fname), true))
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local open_bufnr = vim.api.nvim_win_get_buf(win_id)
    if open_bufnr == bufnr then
      return vim.api.nvim_set_current_win(win_id)
    end
  end
  vim.api.nvim_win_set_buf(0, bufnr)
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

function M.get_syntax_hl_group()
  local win_id = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win_id)
  local stack = vim.fn.synstack(cursor[1], cursor[2])
  dump(vim.tbl_map(function(entry)
    return vim.fn.synIDattr(entry, "name")
  end, stack))
end

function M.sudo_write()
  local bufnr = vim.api.nvim_get_current_buf()
  local readonly = vim.api.nvim_buf_get_option(bufnr, "readonly")
  if readonly then
    vim.cmd [[ silent write !env SUDO_EDITOR=tee VISUAL=tee sudo -e '%' >/dev/null ]]
    vim.api.nvim_buf_set_option(bufnr, "modified", (vim.v.shell_error > 0 or false))
  end
end

return M
