---@class util
---@field buffer util.buffer
---@field callback util.callback
---@field color util.color
---@field excludes util.excludes
---@field fs util.fs
---@field hl util.hl
---@field icons util.icons
---@field plugin util.plugin
---@field ui util.ui
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require(string.format("util.%s", k))
    return t[k]
  end,
})

local tbl_keys_numeric = function(list)
  for k, _ in pairs(list) do
    if type(k) ~= "number" then return false end
  end
  return true
end

---Check if any of the key-value pairs in a given table satisfies the provided condition
---and returns true if the condition is satisfied at least once. Returns false otherwise
---@generic T: table
---@param list T[] | table
---@param callback fun(value: any, key: string | number)
function M.any(list, callback)
  for k, v in pairs(list) do
    if callback(v, k) then return true end
  end
  return false
end

---Creates (and clears if previously defined) a new autocommand group.
---The autocommand will be prefixed with "ds_" to avoid namespace collisions
---@param name string
---@return number
function M.augroup(name) return vim.api.nvim_create_augroup("ds_" .. name, { clear = true }) end

---Searches for a partial match of a string `needle` in a list `haystack`
---@param haystack string[]
---@param needle string
---@return boolean, number # Returns true if found and the position in the list
function M.contains(haystack, needle)
  local found = false
  local pos = -1
  for k, v in pairs(haystack) do
    local safe_v = string.gsub(v, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
    local match = string.match(needle, safe_v) or ""
    if v == needle or #match > 0 then
      found = true
      pos = k
      break
    end
  end
  return found, pos
end

---Limit the rate at which the provided function `callback` will execute
---by delaying it's execution for `delay` milliseconds
---@param callback fun(...)
---@param delay number
---@return function
function M.debounce(callback, delay)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = vim.F.pack_len(...)
    timer:start(delay, 0, function()
      timer:stop()
      vim.schedule_wrap(callback)(vim.F.unpack_len(argv))
    end)
  end
end

---Iterate over each key-value pair in the provided table and apply the callback function.
---If the keys in the table are all numeric, it will perform an ordered iteration over each pair.
---Otherwise the order will not be guaranteed
---@generic T:table
---@param callback fun(item: T, key: any)
---@param list table<any, T>
function M.foreach(list, callback)
  if tbl_keys_numeric(list) then
    for i, v in ipairs(list) do
      callback(v, i)
    end
  else
    for k, v in pairs(list) do
      callback(v, k)
    end
  end
end

---Prints the location and line number of the current stack level
function M.get_location()
  local me = debug.getinfo(1, "S")
  local level = 2
  local info = debug.getinfo(level, "S")
  while info and info.source == me.source do
    level = level + 1
    info = debug.getinfo(level, "S")
  end
  info = info or me
  local source = info.source:sub(2)
  source = vim.uv.fs_realpath(source) or source
  return ("%s:%s"):format(source, info.linedefined)
end

---Prints the lua formatted representation of `filepath` as a module
---@param filepath string
---@return string modname
function M.get_module(filepath)
  local mod, sep
  sep = ds.has "win32" and "\\" or "/"
  mod = filepath:match(("lua%s(.+)%.lua$"):format(sep)):gsub(sep, "."):gsub("%.init", "")
  return mod or ""
end

---Wrapper for Vim's `|has|`feature detection function
---@param feature string
---@return boolean
function M.has(feature) return vim.fn.has(feature) > 0 end

---Creates a new table populated with the results of calling a provided function
---on every key-value pair in the calling table when the key is a string
---@generic T: table, S
---@param list T[] | table
---@param callback fun(acc: S, item: T, key: string): S
---@return S
function M.kmap(list, callback)
  return M.kreduce(list, function(acc, v, k)
    table.insert(acc, callback(v, k))
    return acc
  end, {})
end

---Converts a list of items into a value by iterating over each pair and when the key is a string
---transform the pair with a callback function
---@generic T: table, S
---@param list T[] | table
---@param callback fun(acc: S, item: T, key: string): S
---@param acc S?
---@return S
function M.kreduce(list, callback, acc)
  for k, v in pairs(list) do
    if type(k) == "string" then acc = callback(acc, v, k) end
  end
  return acc
end

---Creates a new table populated with the results of calling a provided function
---on every key-value pair in the calling table
---@generic T: table
---@param list T[] | table
---@param callback fun(item: T, key: string | number, list): T
---@return T[] #A new table with each key-value pair being the result of the callback function
function M.map(list, callback)
  return M.reduce(list, function(acc, v, k)
    table.insert(acc, callback(v, k))
    return acc
  end, {})
end

---Converts a list of items into a value by iterating over each pair and transforming them
---with a callback function.
---If the keys in the table are all numeric, it will perform an ordered iteration over each pair.
---Otherwise the order will not be guaranteed
---@generic T: table, S
---@param list T[] | table
---@param callback fun(acc: S, item: T, key: string | number): S
---@param acc S?
---@return S
function M.reduce(list, callback, acc)
  acc = acc or {}
  if tbl_keys_numeric(list) then
    for i, v in ipairs(list) do
      acc = callback(acc, v, i)
      assert(acc ~= nil, "The accumulator must be returned on each iteration")
    end
  else
    for k, v in pairs(list) do
      acc = callback(acc, v, k)
      assert(acc ~= nil, "The accumulator must be returned on each iteration")
    end
  end
  return acc
end

---@alias util.notifyOpts {lang?:string, title?:string, level?:number, merge?: boolean, location?: string}
---Displays a notification containing a human-readable representation of the object(s) provided
---@param msg string|string[]
---@param opts? util.notifyOpts
function M.notify(msg, opts)
  opts = opts or {}
  opts.level = opts.level or vim.log.levels.INFO
  opts.location = opts.location or M.get_location()
  opts.title = opts.title or ("Debug: " .. opts.location)
  if vim.in_fast_event() then return vim.schedule(function() M.notify(msg, opts) end) end
  opts.location = vim.fn.fnamemodify(opts.location, ":~:.")
  if type(msg) == "table" and opts.merge then
    ---@diagnostic disable-next-line: return-type-mismatch
    msg = vim.tbl_filter(function(line) return line or false end, msg)
    for k, v in pairs(msg) do
      if type(v) == "table" then msg[k] = vim.inspect(v) end
    end
    msg = table.concat(msg, "\n")
  end
  if not opts.merge then msg = vim.inspect(msg) end
  vim.notify(msg, tonumber(opts.level), {
    on_open = function(win)
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].cursorline = false
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, "lua") then vim.bo[buf].filetype = "lua" end
    end,
  })
end

---Display an informational notification
---@param msg string|string[]
---@param opts? util.notifyOpts
function M.info(msg, opts)
  opts = opts or {}
  opts.title = opts.title or "Info"
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

---Display a warning notification
---@param msg string|string[]
---@param opts? util.notifyOpts
function M.warn(msg, opts)
  opts = opts or {}
  opts.title = opts.title or "Warning"
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

---Display an error notification
---@param msg string|string[]
---@param opts? util.notifyOpts
function M.error(msg, opts)
  opts = opts or {}
  opts.title = opts.title or "Error"
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

---"Pretty prints" the given arguments and returns them unmodified. The result is shown as a notification
---@param ...? any
function M.print(...)
  local value = { ... }
  if vim.tbl_isempty(value) then
    value = nil
  else
    value = (vim.islist or vim.islist)(value) and vim.tbl_count(value) <= 1 and value[1] or value
  end
  M.notify(value, { title = "Debug", location = M.get_location() })
end

vim.print = M.print

---Adds whitespace to the start, end or both start and end of a string
---@param s string
---@param direction "left"|"right"|"both"
---@param amount? number #Repeat pad `n` times to the left/right of string or both sides
---@param ramount? number #Repeat pad `n` times to the right of string
---@return string result
function M.pad(s, direction, amount, ramount)
  amount = vim.F.if_nil(amount, 1)
  ramount = vim.F.if_nil(ramount, amount)
  local left = (direction == "left" or direction == "both") and string.rep(" ", amount) or ""
  local right = (direction == "right" or direction == "both") and string.rep(" ", ramount) or ""
  return string.format("%s%s%s", left, s, right)
end

---Perform a benchmark of a given command
---@param cmd string|function
function M.profile(cmd, times)
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
function M.reload(modname)
  local ok, r = pcall(require, "plenary.reload")
  if ok then r.reload_module(modname) end
  return require(modname)
end

---Escapes special characters before performing string substitution
---@param str string
---@param pattern string
---@param repl string|number|table|function
---@param n? integer
---@return string
---@return integer count
function M.replace(str, pattern, repl, n)
  pattern = string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  repl = string.gsub(repl, "[%%]", "%%%%") -- escape replacement
  return string.gsub(str, pattern, repl, n)
end

function M.match(str, pattern, init)
  pattern = string.gsub(pattern, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
  return string.match(str, pattern, init)
end

---Provides a machine-local way of disabling various custom configuration options/settings
---@param setting string
---@return boolean enabled
function M.setting_enabled(setting)
  local var = "config_" .. setting
  if vim.g[var] == nil then return true end
  return vim.g[var] == true
end

---Recursive filesystem walker that traverses `path` and
---applies a provided function `fn` to each file or directory it encounters
---@param path string
---@param fn fun(path: string, name:string, type:FileType)
function M.walk(path, fn)
  M.walker(path, function(child, name, type)
    if type == "directory" then M.walk(child, fn) end
    fn(child, name, type)
  end)
end

---@diagnostic disable-next-line: duplicate-doc-alias
---@alias FileType "file"|"directory"|"link"
---Filesystem walker that iterates over each file or directory in a given `path`,
---applying the function `fn` to each, and stops if `fn` returns `false`.
---@param path string
---@param fn fun(path: string, name:string, type:FileType):boolean?
function M.walker(path, fn)
  if not vim.uv.fs_stat(path) then
    local rtpaths = vim.api.nvim_list_runtime_paths()
    for _, rtp in ipairs(rtpaths) do
      local check = rtp .. "/" .. path
      if vim.uv.fs_stat(check) then
        path = check
        break
      elseif vim.uv.fs_stat(rtp .. "/lua/" .. path) then
        path = rtp .. "/lua/" .. path
      end
    end
  end
  local handle = vim.uv.fs_scandir(path)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then break end
    local fname = path .. "/" .. name
    if fn(fname, name, t or vim.uv.fs_stat(fname).type) == false then break end
  end
end

return M
