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
local hex_to_rgb = function(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
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

function M.blend(foreground, background, alpha)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = hex_to_rgb(background)
  local fg = hex_to_rgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
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
