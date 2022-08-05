local M = {}

function M.create_scratch()
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

function M.delete_buffer(force)
  local buflisted = vim.fn.getbufinfo { buflisted = 1 }
  if #buflisted < 2 then
    vim.cmd "enew"
    return
  end
  local winnr = vim.fn.winnr()
  local bufnr = vim.fn.bufnr()
  for _, winid in ipairs(vim.fn.getbufinfo(bufnr)[1].windows) do
    vim.cmd(string.format("%d wincmd w", vim.fn.win_id2win(winid)))
    if bufnr == buflisted[#buflisted].bufnr then
      vim.cmd "bp"
    else
      vim.cmd "bn"
    end
  end
  vim.cmd(string.format("%d wincmd w", winnr))
  if force or vim.fn.getbufvar(bufnr, "&buftype") == "terminal" then
    vim.cmd "bd! #"
  else
    vim.cmd "silent! confirm bd #"
  end
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

function M.sudo_write()
  local function get_password()
    vim.fn.inputsave()
    local user = vim.fn.expand "$USER"
    local pw = vim.fn.inputsecret(string.format("Provide the password for %s: ", user))
    vim.fn.inputrestore()
    return pw
  end

  local function test(pw, k)
    local stdin = vim.loop.new_pipe()
    vim.loop.spawn("sudo", {
      args = { "-S", "-k", "true" },
      stdio = { stdin, nil, nil },
    }, k)

    stdin:write(pw)
    stdin:write "\n"
    stdin:shutdown()
  end

  local function write(pw, buf, lines, k)
    local stdin = vim.loop.new_pipe()
    vim.loop.spawn("sudo", {
      args = { "-S", "-k", "tee", buf },
      stdio = { stdin, nil, nil },
    }, k)

    stdin:write(pw)
    stdin:write "\n"
    local last = table.remove(lines)
    for _, line in ipairs(lines) do
      stdin:write(line)
      stdin:write "\n"
    end
    stdin:write(last)
    stdin:shutdown()
  end

  local pw = get_password()
  local buf = vim.api.nvim_buf_get_name(0)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  local function exitWrite(code, _)
    if code == 0 then
      vim.schedule(function()
        vim.api.nvim_echo({ { string.format('"%s" written', buf), "Normal" } }, true, {})
        vim.api.nvim_buf_set_option(0, "modified", false)
      end)
    end
  end
  local function exitTest(code, _)
    if code == 0 then
      write(pw, buf, lines, exitWrite)
    else
      vim.schedule(function()
        vim.api.nvim_echo({ { "Incorrect password", "ErrorMsg" } }, true, {})
      end)
    end
  end
  test(pw, exitTest)
end

return M
