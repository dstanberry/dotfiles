local defaults = require "ui.theme.defaults"

---@class ColorPalette
---@field aqua0 string
---@field aqua1 string
---@field aqua2 string
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field bg4 string
---@field bg_visual string
---@field bgX string
---@field black string
---@field blue0 string
---@field blue1 string
---@field blue2 string
---@field blue3 string
---@field blue4 string
---@field cyan0 string
---@field cyan1 string
---@field cyan2 string
---@field diff_add string
---@field diff_change string
---@field diff_delete string
---@field diff_text string
---@field fg0 string
---@field fg1 string
---@field fg2 string
---@field fg_comment string
---@field fg_conceal string
---@field gray0 string
---@field gray1 string
---@field gray2 string
---@field grayX string
---@field green0 string
---@field green1 string
---@field green2 string
---@field magenta0 string
---@field magenta1 string
---@field magenta2 string
---@field orange0 string
---@field orange1 string
---@field purple0 string
---@field purple1 string
---@field red0 string
---@field red1 string
---@field red2 string
---@field red3 string
---@field rose0 string
---@field rose1 string
---@field white string
---@field yellow0 string
---@field yellow1 string
---@field yellow2 string

---@alias Colorscheme "kdark"|"catppuccin-frappe"|"catppuccin-mocha"
---@alias Background "light"|"dark"
---@alias Theme table<Colorscheme,ColorPalette>

local M = {}

---@class Colorschemes table<Colorscheme,Theme>
M.themes = {}

M._initialized = false

---Sets the active neovim theme based on the provided `colorscheme`
---@param t Colorscheme
---@param b? Background
M.load = function(t, b)
  b = b or "dark"
  if not M._initialized then
    M._initialized = true
    local root = "ui/theme/palette"
    ds.walk(root, function(path, name, type)
      if (type == "file" or type == "link") and name:match "%.lua$" then
        local mod = path:match(root .. "/(.*)"):sub(1, -5):gsub("/", ".")
        name = name:sub(1, -5)
        if mod:match "%." then name = mod:gsub("%.", "_") end
        M.themes[name] = require(root:gsub("/", ".") .. "." .. mod)
      end
    end)
  end
  if t and M.themes[t] then
    vim.o.background = "dark"
    vim.g.colors_name = t
    vim.g.ds_colors = M.themes[t]
    ds.hl.apply(vim.g.ds_colors, defaults)
  end
end

return M
