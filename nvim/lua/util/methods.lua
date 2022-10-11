---Global callback store to prevent loss of information if this file is reloaded
_G.__UtilCallbackStore = _G.__UtilCallbackStore or {}

local M = {
  _callbackStore = _G.__UtilCallbackStore,
}

---Adds a class or function to the callback store
---@param key any
---@param callback function|table
function M._create_callback(key, callback)
  M._callbackStore[key] = callback
end

---Execute a callback stored at the id provided
---@param id any
function M._execute_callback(id)
  local func = M._callbackStore[id]
  if not (func and (type(func) == "function" or type(func) == "table")) then
    error(("Function does not exist: %s"):format(id))
  end
  return func()
end

---Adds a class or function to the callback store and returns a Vim safe funcref to it
---@param cb any
---@param expr boolean
---@return string funcref
function M.add_callback(cb, expr)
  local key = tostring(cb)
  M._create_callback(key, cb)
  if expr then
    return ([[luaeval('require("util.methods")._execute_callback("%s")')]]):format(key)
  end
  return ([[lua require("util.methods")._execute_callback("%s")]]):format(key)
end

return M
