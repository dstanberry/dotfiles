---@class util
---@field buffer util.buffer
---@field cmp util.cmp
---@field color util.color
---@field colorcolumn util.colorcolumn
---@field env util.env
---@field format util.format
---@field fs util.fs
---@field ft util.ft
---@field hl util.hl
---@field icons util.icons
---@field plugin util.plugin
---@field root util.root
---@field snippet util.snippet
---@field treesitter util.treesitter
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util." .. k)
    return rawget(t, k)
  end,
})

---Creates (and clears if previously defined) a new autocommand group.
---The autocommand will be prefixed with "ds." to avoid namespace collisions
---@param name string
---@return number
function M.augroup(name) return vim.api.nvim_create_augroup("ds." .. name, { clear = true }) end

---Logs a message at the INFO log level using `vim.notify`
function M.info(msg, opts) vim.notify(type(msg) ~= "string" and vim.inspect(msg) or msg, vim.log.levels.INFO, opts) end

---Logs a message at the WARN log level using `vim.notify`
function M.warn(msg, opts) vim.notify(type(msg) ~= "string" and vim.inspect(msg) or msg, vim.log.levels.WARN, opts) end

---Logs a message at the ERROR log level using `vim.notify`
function M.error(msg, opts) vim.notify(type(msg) ~= "string" and vim.inspect(msg) or msg, vim.log.levels.ERROR, opts) end

---Map a list of action names to their corresponding functions.
---If an action is found and returns a truthy value, the mapping stops.
---If no action is found or all return falsy values, the fallback is executed.
---Actions are resolved as dot-separated paths within the util module. (e.g., `{ "cmp.accept", "cmp.inline.accept" }`)
---@param actions string[] List of action names as dot-separated module paths
---@param fallback? string|fun(): any Optional fallback executed if all actions fail or return falsy
---@return fun(): boolean|string|any Function that executes the action chain and returns:
---  - `true` if any action succeeds
---  - fallback result if provided and all actions fail
---  - `nil` if no fallback and all actions fail
function M.coalesce(actions, fallback)
  return function()
    for _, action_name in ipairs(actions) do
      local func = action_name:match "([^.]+)$"
      local mod = action_name:gsub("%." .. vim.pesc(func) .. "$", "")
      local target = mod == func and M[func]

      if mod ~= func then
        local parts = vim.split(mod, ".", { plain = true })
        target = vim.tbl_get(M, unpack(parts))
        if target then target = target[func] end
      end
      if type(target) == "function" then
        local result = target()
        if result then return true end
      end
    end
    return type(fallback) == "function" and fallback() or (type(fallback) == "string" and fallback or nil)
  end
end

---Limit the rate at which the provided function `callback` will execute
---by delaying it's execution for `delay` milliseconds
---@param callback fun(...)
---@param delay number
---@return function
function M.debounce(callback, delay)
  local timer = assert(vim.uv.new_timer()) ---@type uv_timer_t
  return function(...)
    local argv = vim.F.pack_len(...)
    timer:start(delay, 0, function()
      timer:stop()
      vim.schedule_wrap(callback)(vim.F.unpack_len(argv))
    end)
  end
end

---Prints the lua formatted representation of `filepath` as a module
---@param filepath string
---@return string modname
function M.get_module(filepath)
  local mod = filepath:match "lua%S(.+)%.lua$"
  if not mod then return "" end
  mod = M.has "win32" and mod:gsub("[/\\]", ".") or mod:gsub("/", ".")
  return mod:gsub("%.init$", "")
end

---Wrapper for Vim's `has` feature detection function
---@param feature string
---@return boolean
function M.has(feature) return vim.fn.has(feature) > 0 end

---Check if any of the key-value pairs in a given table satisfies the provided condition
---and returns true if the condition is satisfied at least once. Returns false otherwise
---@generic T: table
---@param list T[] | table
---@param callback fun(value: any, key: string | number)
function M.tbl_any(list, callback)
  local keys = vim.tbl_keys(list)
  return vim.tbl_contains(keys, true, { predicate = function(k) return callback(list[k], k) end })
end

---Iterate over each key-value pair in the provided table and apply the callback function.
---If the keys in the table are all numeric, it will perform an ordered iteration over each pair.
---Otherwise the order will not be guaranteed
---@generic T:table
---@param list table<any, T>
---@param callback fun(item: T, key: any)
function M.tbl_each(list, callback)
  if vim.isarray(list) then
    for i, v in ipairs(list) do
      callback(v, i)
    end
  else
    for k, v in pairs(list) do
      callback(v, k)
    end
  end
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
function M.tbl_reduce(list, callback, acc)
  acc = acc or {}
  if vim.isarray(list) then
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

---Reverse a list in place.
---This function modifies the input list by reversing its elements.
---@generic T
---@param list T[] The list to be reversed. Must be a table with sequential numeric keys.
---@return T[] The reversed list (same reference as the input list).
function M.tbl_reverse(list)
  local len = #list
  for i = 1, (len / 2) do
    local opposite = len - i + 1
    list[i], list[opposite] = list[opposite], list[i]
  end
  return list
end

local memcache = {} ---@type table<(fun()), table<string, any>>

---Creates a memoized version of the provided function `fn`
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect { ... }
    memcache[fn] = memcache[fn] or {}
    if memcache[fn][key] == nil then memcache[fn][key] = fn(...) end
    return memcache[fn][key]
  end
end

---Adds whitespace to the start, end, or both start and end of a string
---@param s string
---@param direction "left"|"right"|"both"
---@param amount? number #Repeat pad `n` times to the left/right of string or both sides
---@param ramount? number #Repeat pad `n` times to the right of string
---@return string result
function M.pad(s, direction, amount, ramount)
  amount = amount or 1
  ramount = ramount or amount
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
  pattern = vim.pesc(pattern)
  if type(repl) == "string" then repl = string.gsub(repl, "[%%]", "%%%%") end
  return string.gsub(str, pattern, repl, n)
end

---Provides a machine-local way of modifying the default behavior of a plugin or feature
---@param setting string
---@return boolean enabled
function M.setting_enabled(setting)
  local value = M.env.get { "settings", setting }
  return value == true or value == ""
end

---@alias util.keymap_toggle.map fun(string, vim.keymap.set.Opts)
---@alias util.keymap_toggle.opts {desc: string, enabled:string, disabled: string, map:util.keymap_toggle.map, set:fun(state:boolean), get:fun():boolean}

---Generates a configuration table for keymaps to toggle functionality.
---@param opts {name: string, desc: string, set: fun(state:boolean, ...), get: fun():boolean }
---@param ... any Additional arguments to pass to the set function
---@return util.keymap_toggle.opts
function M.toggle_config(opts, ...)
  local setter_args = { ... }
  ---@type util.keymap_toggle.opts
  return {
    enabled = opts.name .. ": disable ",
    disabled = opts.name .. ": enable ",
    desc = opts.desc,
    get = opts.get,
    set = function(state) opts.set(state, unpack(setter_args)) end,
    map = function(lhs, keymap_opts)
      keymap_opts = vim.tbl_deep_extend(
        "force",
        { mode = "n", desc = ("%s: toggle %s"):format(opts.name, opts.desc) },
        keymap_opts or {}
      )
      vim.keymap.set(
        keymap_opts.mode,
        lhs,
        function() opts.set(not opts.get(), unpack(setter_args)) end,
        { desc = keymap_opts.desc, noremap = true, silent = true }
      )
    end,
  }
end

---Creates a "toggle" keymap using the provided key and options.
---@param key string The key combination to map
---@param opts util.keymap_toggle.opts Toggle options containing get, set, desc, etc.
function M.toggle_keymap(key, opts)
  if opts.map and type(opts.map) == "function" then opts.map(key) end
end

return M
