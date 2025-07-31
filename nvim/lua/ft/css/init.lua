---@class ft.css
---@field tailwind ft.css.tailwind
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("ft.css." .. k)
    return rawget(t, k)
  end,
})

return M
