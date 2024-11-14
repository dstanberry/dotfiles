---@class util
---@field buffer util.buffer
---@field callback util.callback
---@field color util.color
---@field excludes util.excludes
---@field fs util.fs
---@field git util.git
---@field hl util.hl
---@field icons util.icons
---@field plugin util.plugin
---@field root util.root
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

---Prints the lua formatted representation of `filepath` as a module
---@param filepath string
---@return string modname
function M.get_module(filepath)
  local mod, sep
  sep = ds.has "win32" and "\\" or "/"
  mod = filepath:match("lua%S(.+)%.lua$"):format(sep):gsub(sep, "."):gsub("%.init", "")
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

---@alias util.notify.opts { ft?: string, title?: string, level?: number, merge?: boolean, on_open?: function }
---Displays a notification containing a human-readable representation of the object(s) provided
---@param msg string|string[]
---@param opts? util.notify.opts
function M.notify(msg, opts)
  local notify = vim.in_fast_event() and vim.schedule_wrap(vim.notify) or vim.notify
  opts = opts or {}
  opts.level = opts.level or vim.log.levels.INFO
  opts.title = opts.title or ""
  if type(msg) == "table" and opts.merge then
    msg = vim.tbl_filter(function(line) return line or false end, msg)
    for k, v in pairs(msg) do
      if type(v) == "table" then msg[k] = vim.inspect(v) end
    end
    msg = table.concat(msg, "\n")
  end
  if not opts.merge then msg = vim.inspect(msg) end
  msg = vim.trim(msg)
  return notify(msg, opts.level, opts)
end

---Show a notification with a pretty printed dump of the object(s) with lua treesitter highlighting
---and the location of the caller
function M.inspect(...)
  local len = select("#", ...) ---@type number
  local obj = { ... } ---@type unknown[]
  local caller = debug.getinfo(1, "S")
  for level = 2, 10 do
    local info = debug.getinfo(level, "S")
    if
      info
      and info.source ~= caller.source
      and info.what == "Lua"
      and info.source ~= "lua"
      and info.source ~= "@" .. vim.env.MYVIMRC
    then
      caller = info
      break
    end
  end
  local title = "Debug: " .. vim.fn.fnamemodify(caller.source:sub(2), ":~:.") .. ":" .. caller.linedefined
  M.warn(vim.inspect(len == 1 and obj[1] or len > 0 and obj or nil), { title = title, ft = "lua" })
end

---Display an informational notification
---@param msg string|string[]
---@param opts? util.notify.opts
function M.info(msg, opts)
  opts = opts or {}
  opts.title = opts.title or "Info"
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

---Display a warning notification
---@param msg string|string[]
---@param opts? util.notify.opts
function M.warn(msg, opts)
  opts = opts or {}
  opts.title = opts.title or "Warning"
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

---Display an error notification
---@param msg string|string[]
---@param opts? util.notify.opts
function M.error(msg, opts)
  opts = opts or {}
  opts.title = opts.title or "Error"
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

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

---Perform a benchmark of a given lua function
---@param fn function
---@param opts? {count?: number, flush?: boolean}
function M.profile(fn, opts)
  opts = vim.tbl_extend("force", { count = 100, flush = true }, opts or {})
  local start = vim.uv.hrtime()
  for _ = 1, opts.count, 1 do
    if opts.flush then jit.flush(fn, true) end
    fn()
  end
  print(((vim.uv.hrtime() - start) / 1e6 / opts.count) .. "ms")
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
  if not vim.g.ds_env.settings or vim.g.ds_env.settings[setting] == nil then return true end
  return vim.g.ds_env.settings[setting] == true
end

---Recursive filesystem walker that traverses `path` and
---applies a provided function `fn` to each file or directory it encounters
---@param path string
---@param fn fun(path: string, name:string, type:util.walker.filetype)
function M.walk(path, fn)
  M.walker(path, function(child, name, type)
    if type == "directory" then M.walk(child, fn) end
    fn(child, name, type)
  end)
end

---@alias util.walker.filetype "file"|"directory"|"link"
---Filesystem walker that iterates over each file or directory in a given `path`,
---applying the function `fn` to each, and stops if `fn` returns `false`.
---@param path string
---@param fn fun(path: string, name:string, type:util.walker.filetype):boolean?
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
