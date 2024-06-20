---Global callback store to prevent loss of information if this file is reloaded
_G.ds.__UtilCallbackStore = _G.ds.__UtilCallbackStore or {}

---@class util.callback
local M = {
  _callbackStore = _G.ds.__UtilCallbackStore,
}

---Execute a callback stored at the id provided
---@param id any
function M.execute(id)
  local func = M._callbackStore[id]
  if not (func and (type(func) == "function" or type(func) == "table")) then
    error(("Function does not exist: %s"):format(id))
  end
  return func()
end

---Adds a class or function to the callback store and returns a Vim safe funcref to it
---@param cb function|table
---@param expr boolean
---@return string funcref
function M.create(cb, expr)
  local key = tostring(cb)
  M._callbackStore[key] = cb
  if expr then return ([[luaeval('require("util.callback").execute("%s")')]]):format(key) end
  return ([[lua require("util.callback").execute("%s")]]):format(key)
end

return M
