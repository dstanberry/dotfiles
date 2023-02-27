local M = {}

---Prints lua formatted representation of the given file as a module
---@param filename string
---@return string modname
function M.get_module_name(filename)
  local modname
  if has "win32" then
    modname = (filename):match "lua\\(.+)%.lua$"
    if modname ~= nil then
      modname = (modname):gsub("\\", ".")
    end
  else
    modname = (filename):match "lua/(.+)%.lua$"
    if modname ~= nil then
      modname = (modname):gsub("/", ".")
    end
  end
  modname = (modname):gsub(".init", "")
  return modname or ""
end

---Creates a new table populated with the results of calling a provided function
--on every key-value pair in the calling table.
---@generic T : table
---@param callback fun(T, T, key: string | number): T
---@param list T[]
---@param newList T?
---@return T #A new table with each key-value pair being the result of the callback function
function M.map(callback, list, newList)
  newList = newList or {}
  for k, v in pairs(list) do
    newList = callback(newList, v, k)
    if newList == nil then
      error "|newList| must be returned on each iteration and cannot be null"
    end
  end
  return newList
end

---Unloads the provided module from memory and re-requires it
---@param modname string
function M.reload(modname)
  local ok, r = pcall(require, "plenary.reload")
  if ok then
    r.reload_module(modname)
  end
  return require(modname)
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
