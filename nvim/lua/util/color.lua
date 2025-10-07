---@class util.color
---@overload fun(name?: string)
local M = setmetatable({}, {
  __call = function(m, ...) return m.get_palette(...) end,
})

local clamp = function(val, min, max)
  if val == nil then return end
  if val < min then
    return min
  elseif val > max then
    return max
  end
  return val
end

local hex_to_rgb = function(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

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

---Blends two colors together based on the alpha value.
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

---Adjusts the brightness of a color by a given amount.
---@param hex string hexadecimal color formatted as `#rrggbb``
---@param amount integer amout to adjust by
--- - `amount` < 1 : adjusted to 1 - amount
--- - `amount` >=1 : adjusted to 1 - (amount / 100)
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

---Retrieves the color of a highlight group.
---@param name string highlight group name
---@param bg? boolean return the background color if `true` otherwise return the foreground color
---@return string? #hexadecimal color formatted as `#rrggbb`
function M.get(name, bg)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  local color = nil
  if hl then
    if bg then
      color = hl.bg or hl.background
    else
      color = hl.fg or hl.foreground
    end
  end
  return color and string.format("#%06x", color) or nil
end

---Retrieves a color from the active colorscheme palette.
---@param name? string color name
---@return string?,util.theme.palette? #hexadecimal color formatted as `#rrggbb` or the entire palette if `name` is not provided
M.get_palette = function(name) return name and vim.tbl_get(vim.g, "ds_colors", name) or vim.g.ds_colors end

---Adjusts the brightness of a color by a given amount.
---@param hex string hexadecimal color formatted as `#rrggbb``
---@param amount integer amout to adjust by
--- - `amount` < 1 : adjusted to 1 - amount
--- - `amount` >=1 : adjusted to 1 - (amount / 100)
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

--- If supported, change the background color of the terminal emulator to match the current `colorscheme`
function M.sync_term_bg()
  local group = ds.augroup "util.terminal.color"

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
    if not ok or type(original_bg) ~= "string" then original_bg = ds.color "bg2" end

    local sync_bg = function()
      local bg = ds.color.get("Normal", true)
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
