local M = {}

M.color = require "util.color"
M.buffer = require "util.buffer"
M.map = require "util.map"
M.packer = require "util.packer"

function M.reload(name)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(name)
  end
  return require(name)
end

M.callbacks = {}

function M.delegate(cb, expr)
  local key = tostring(cb)
  M.callbacks[key] = cb
  if expr then
    return ([[luaeval('require("util").execute("%s")')]]):format(key)
  end
  return ([[lua require("util").execute("%s")]]):format(key)
end

function M.execute(id)
  local func = M.callbacks[id]
  if not func then
    error("Function doest not exist: " .. id)
  end
  return func()
end

function M.define_autocmd(spec)
  local event = spec.event
  if type(event) == "table" then
    event = table.concat(event, ",")
  end
  local pattern = spec.pattern or "*"
  if type(pattern) == "table" then
    pattern = table.concat(pattern, ",")
  end
  local once = spec.once and "++once" or ""
  local nested = spec.nested and "++nested" or ""
  local action = spec.command or ""
  if spec.callback ~= nil and type(spec.callback) == "function" then
    action = M.delegate(spec.callback)
  end
  local command = table.concat(vim.tbl_flatten { "autocmd", event, pattern, once, nested, action }, " ")
  vim.api.nvim_command(command)
end

function M.define_augroup(group)
  local clear_suffix = group.buf and " * <buffer>" or ""
  vim.api.nvim_command("augroup " .. group.name)
  vim.api.nvim_command("autocmd!" .. clear_suffix)
  for _, autocmd in ipairs(group.autocmds) do
    M.define_autocmd(autocmd)
    vim.api.nvim_command "augroup END"
  end
end

function M.load_dirhash(s)
  if s == nil then
    error "cannot load hashes without specifying shell"
    return
  end
  local shell
  if s:find "bash" then
    shell = "bash"
  elseif s:find "zsh" then
    shell = "zsh"
  else
    shell = s
  end
  if shell ~= "bash" and shell ~= "zsh" then
    error("cannot load hashes for unsupported shell: " .. shell)
    return
  end
  local path = vim.fn.expand(("%s/%s/rc.private/hashes.%s"):format(vim.env.XDG_CONFIG_HOME, shell, shell))
  local cmd = ([[%s -c "source %s; hash -d"]]):format(shell, path)
  local dirs = vim.fn.system(cmd)
  local lines = vim.split(dirs, "\n")
  for _, line in pairs(lines) do
    local pair = vim.split(line, "=")
    if #pair == 2 then
      local var = pair[1]
      local dir = pair[2]
      if vim.env["hash_" .. var] == nil then
        vim.env["hash_" .. var] = dir
      end
    end
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

function M.get_visual_selection(clear)
  local bufnr = 0
  local visual_modes = {
    v = true,
    V = true,
  }
  if visual_modes[vim.api.nvim_get_mode().mode] == nil then
    return
  end
  if clear then
    vim.cmd [[execute "normal! \<esc>"]]
  end
  local options = {}
  options.adjust = function(pos1, pos2)
    if vim.fn.visualmode() == "V" then
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

return M
