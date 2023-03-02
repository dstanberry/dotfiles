---Prints a human-readable representation of the object(s) provided
---@param ...? any
---@return string[] result
function _G.dump(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  ---@diagnostic disable-next-line: discard-returns
  print(table.concat(objects, "\n"))
  return ...
end

---Prints a human-readable representation of the object(s) provided and places the result in the current buffer
---@param ...? any
---@return string[] result
function _G.dump_text(...)
  local objects = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  vim.schedule(function()
    local lines = vim.split(table.concat(objects, "\n"), "\n")
    local lnum = vim.api.nvim_win_get_cursor(0)[1]
    vim.fn.append(lnum, lines)
  end)
  return ...
end

---Wrapper for Vim's `|has|`feature detection function
---@param feature string
---@return boolean
function _G.has(feature) return vim.fn.has(feature) > 0 end

---Adds whitespace to the start, end or both start and end of a string
---@param s string
---@param direction string
---@return string result
function _G.pad(s, direction)
  local left = (direction == "left" or direction == "both") and " " or ""
  local right = (direction == "right" or direction == "both") and " " or ""
  return string.format("%s%s%s", left, s, right)
end

---Perform a benchmark of a given command
---@param cmd string|function
function _G.profile(cmd, times)
  times = times or 100
  local args = {}
  if type(cmd) == "string" then
    args = { cmd }
    cmd = vim.cmd
  end
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then error("Command failed: " .. tostring(ok) .. " " .. vim.inspect { cmd = cmd, args = args }) end
  end
  ---@diagnostic disable-next-line: discard-returns
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. "ms")
end

---Unloads the provided module from memory and re-requires it
---@param modname string
function _G.reload(modname) return require("util").reload(modname) end

---Provides a machine-local way of disabling various custom configuration options/settings
---@param setting string
---@return boolean enabled
function _G.setting_enabled(setting)
  local var = "config_" .. setting
  if vim.g[var] == nil then return true end
  return vim.g[var] == 1
end
