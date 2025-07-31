---@class ft.css.tailwind
---@overload fun(): table<ft.css.tailwind.shade, ft.css.tailwind.colors>
local M = setmetatable({}, {
  __call = function(m, ...) return m.get_colors(...) end,
})

---@alias ft.css.hex string
---@alias ft.css.tailwind.shade string
---@alias ft.css.tailwind.shade.level 50|100|200|300|400|500|600|700|800|900|950
---@alias ft.css.tailwind.colors table<ft.css.tailwind.shade.level, ft.css.hex>

---Tailwind CSS color palettes.
---Keys are color names, values are tables mapping shade numbers to hex codes.
---@return table<ft.css.tailwind.shade, ft.css.tailwind.colors>
function M.get_colors()
  local colors = require "ft.css.tailwind.colors"
  return colors
end

return M
