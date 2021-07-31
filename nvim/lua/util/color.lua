---------------------------------------------------------------
-- => Color Manipulation
---------------------------------------------------------------
local M = {}

-- return value within range boundary
local clamp = function(val, min, max)
  if val == nil then
    return
  end
  if val < min then
    return min
  elseif val > max then
    return max
  end
  return val
end

-- convert hex to rgb
local hex_to_rgb = function(hex)
  hex = hex:gsub("#", "")
  return {
    tonumber("0x" .. hex:sub(1, 2)),
    tonumber("0x" .. hex:sub(3, 4)),
    tonumber("0x" .. hex:sub(5, 6)),
  }
end

-- convert hex to rgb
local rgb_to_hex = function(rgb)
  local hex = ""
  for _, v in pairs(rgb) do
    hex = hex .. ("%02X"):format(v)
  end
  return "#" .. hex
end

local saturate = function(rgb, amount)
  local c = {}
  for i, v in ipairs(rgb) do
    c[i] = clamp(v * amount, 0, 255)
  end
  return c
end

function M.darken(hex, amount)
  if amount < 1 then
    amount = 1 - amount
  else
    amount = 1 - (amount / 100)
  end
  local rgb = hex_to_rgb(hex)
  rgb = saturate(rgb, amount)
  return rgb_to_hex(rgb)
end

function M.lighten(hex, amount)
  if amount < 1 then
    amount = 1 + amount
  else
    amount = 1 + (amount / 100)
  end
  local rgb = hex_to_rgb(hex)
  rgb = saturate(rgb, amount)
  return rgb_to_hex(rgb)
end

return M
