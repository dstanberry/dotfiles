---@class util.color
local M = {}

-- return value within range boundary
local clamp = function(val, min, max)
  if val == nil then return end
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

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
---@return string color
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

---@param hex string
---@param amount integer
---@return string color
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

---@param name string
---@param bg? boolean
---@return string?
function M.get_color(name, bg)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  local color = nil
  if hl then
    if bg then
      ---@diagnostic disable-next-line: undefined-field
      color = hl.bg or hl.background
    else
      ---@diagnostic disable-next-line: undefined-field
      color = hl.fg or hl.foreground
    end
  end
  return color and string.format("#%06x", color) or nil
end

---@param hex string
---@param amount integer
---@return string color
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

function M.sync_term_bg()
  local group = ds.augroup "terminal_emulator"

  local parse_osc11 = function(sequence)
    local r, g, b = sequence:match "^\027%]11;rgb:(%x+)/(%x+)/(%x+)$"
    if not (r and g and b) then
      local a
      r, g, b, a = sequence:match "^\027%]11;rgba:(%x+)/(%x+)/(%x+)/(%x+)$"
      if not (a and a:len() <= 4) then return end
    end
    if not (r and g and b) then return end
    if not (r:len() <= 4 and g:len() <= 4 and b:len() <= 4) then return end
    local parse_osc_hex = function(c) return c:len() == 1 and (c .. c) or c:sub(1, 2) end
    return "#" .. parse_osc_hex(r) .. parse_osc_hex(g) .. parse_osc_hex(b)
  end

  local handle_term_reponse = function(args)
    local ok, original_bg = pcall(parse_osc11, args.data)
    if not ok or type(original_bg) ~= "string" then original_bg = "#373737" end

    local sync_bg = function()
      local bg = ds.color.get_color("Normal", true)
      if bg == nil then return end
      if os.getenv "TMUX" then
        vim.fn.system "tmux set-option allow-passthrough on"
        os.execute(string.format('printf "\\ePtmux;\\e\\033]11;%s\\007\\e\\\\"', bg))
        vim.fn.system "tmux set-option allow-passthrough off"
      else
        io.write(string.format("\027]11;%s\007", bg))
      end
    end
    vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter" }, { group = group, callback = sync_bg })

    vim.api.nvim_create_autocmd("UILeave", {
      group = group,
      callback = function()
        if os.getenv "TMUX" then
          vim.fn.system "tmux set-option allow-passthrough on"
          os.execute(string.format('printf "\\ePtmux;\\e\\033]11;%s\\007\\e\\\\"', original_bg))
          vim.fn.system "tmux set-option allow-passthrough off"
        else
          io.write("\027]11;" .. original_bg .. "\007")
        end
      end,
    })
    sync_bg()
  end

  local term_response = vim.api.nvim_create_autocmd("TermResponse", {
    group = group,
    once = true,
    nested = true,
    callback = handle_term_reponse,
  })

  io.write "\027]11;?\007"
  vim.defer_fn(function()
    local res = pcall(vim.api.nvim_del_autocmd, term_response)
    if res then
      -- no response from the terminal so... guess the background color
      handle_term_reponse ""
    end
  end, 1000)
end

return M
