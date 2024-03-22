---Displays a notification containing a human-readable representation of the object(s) provided
---@param title string
---@param ...? any
function _G.dump_with_title(title, ...)
  local get_value = function(...)
    local value = { ... }
    return vim.tbl_islist(value) and vim.tbl_count(value) <= 1 and value[1] or value
  end
  require("util.debug").dump(get_value(...),  { title = title })
end

---Displays a notification containing a human-readable representation of the object(s) provided
---@param ...? any
function _G.dump(...)
  local get_value = function(...)
    local value = { ... }
    return vim.tbl_islist(value) and vim.tbl_count(value) <= 1 and value[1] or value
  end
  require("util.debug").dump(get_value(...))
end

vim.print = _G.dump

---Wrapper for Vim's `|has|`feature detection function
---@param feature string
---@return boolean
function _G.has(feature) return vim.fn.has(feature) > 0 end

---Adds whitespace to the start, end or both start and end of a string
---@param s string
---@param direction string
---@param amount? number #Repeat pad `n` times to the left/right of string or both sides
---@param ramount? number #Repeat pad `n` times to the right of string
---@return string result
function _G.pad(s, direction, amount, ramount)
  amount = vim.F.if_nil(amount, 1)
  ramount = vim.F.if_nil(ramount, amount)
  local left = (direction == "left" or direction == "both") and string.rep(" ", amount) or ""
  local right = (direction == "right" or direction == "both") and string.rep(" ", ramount) or ""
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
  local start = vim.uv.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then error("Command failed: " .. tostring(ok) .. " " .. vim.inspect { cmd = cmd, args = args }) end
  end
  ---@diagnostic disable-next-line: discard-returns
  print(((vim.uv.hrtime() - start) / 1000000 / times) .. "ms")
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
  return vim.g[var] == true
end
