_G.dump = function(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

---@diagnostic disable-next-line: discard-returns
  print(table.concat(objects, "\n"))
  return ...
end

_G.dump_text = function(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  local lines = vim.split(table.concat(objects, "\n"), "\n")
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(lnum, lines)
  return ...
end

_G.has = function(feature)
  return vim.fn.has(feature) > 0
end

_G.pad = function(s, direction)
  local left = (direction == "left" or direction == "both") and " " or ""
  local right = (direction == "right" or direction == "both") and " " or ""
  return string.format("%s%s%s", left, s, right)
end

_G.profile = function(cmd, times)
  times = times or 100
  local args = {}
  if type(cmd) == "string" then
    args = { cmd }
    cmd = vim.cmd
  end
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then
      error("Command failed: " .. tostring(ok) .. " " .. vim.inspect { cmd = cmd, args = args })
    end
  end

---@diagnostic disable-next-line: discard-returns
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. "ms")
end

_G.reload = require("util").reload

_G.setting_enabled = function(setting)
  local var = "config_" .. setting
  if vim.g[var] == nil then
    return true
  end
  return vim.g[var] == 1
end
