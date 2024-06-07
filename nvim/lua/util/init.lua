local M = {}

local tbl_keys_numeric = function(list)
  for k, _ in pairs(list) do
    if type(k) ~= "number" then return false end
  end
  return true
end

---Check if any of the key-value pairs in a given table satisfies the provided condition
---and returns true if the condition is satisfied at least once. Returns false otherwise
---@generic T: table
---@param list T[]
---@param callback fun(value: any, key: string | number)
function M.any(list, callback)
  for k, v in pairs(list) do
    if callback(v, k) then return true end
  end
  return false
end

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
function M.debounce(callback, delay)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:stop()
    timer:start(delay, 0, function()
      pcall(
        vim.schedule_wrap(function(...)
          callback(...)
          timer:stop()
        end),
        select(1, unpack(argv))
      )
    end)
  end,
    timer
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

---Prints lua formatted representation of the given string `filename` as a lua module
---@param filename string
---@return string modname
function M.get_module_name(filename)
  local modname
  if ds.has "win32" then
    modname = (filename):match "lua\\(.+)%.lua$"
    if modname ~= nil then modname = (modname):gsub("\\", ".") end
  else
    modname = (filename):match "lua/(.+)%.lua$"
    if modname ~= nil then modname = (modname):gsub("/", ".") end
  end
  modname = (modname):gsub(".init", "")
  return modname or ""
end

---Creates a new table populated with the results of calling a provided function
---on every key-value pair in the calling table when the key is a string
---@generic T : table, S
---@param list T[]
---@param callback fun(acc: S, item: T, key: string): S
---@param acc S?
---@return S
function M.kmap(list, callback)
  return M.kreduce(list, function(acc, v, k)
    table.insert(acc, callback(v, k))
    return acc
  end, {})
end

---Converts a list of items into a value by iterating over each pair and when the key is a string
---transform the pair with a callback function
---@generic T : table, S
---@param list T[]
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
---@generic T : table
---@param list T[]
---@param callback fun(item: T, key: string | number, list: T[]): T
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
---@generic T : table, S
---@param list T[]
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

return setmetatable({}, {
  __index = function(t, k)
    if M[k] then
      return M[k]
    else
      local ok, val = pcall(require, string.format("util.%s", k))
      if ok then
        rawset(t, k, val)
        return val
      end
    end
  end,
})
