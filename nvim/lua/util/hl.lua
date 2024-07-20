---@class util.hl
local M = {}

local _cached_highlights = {}

---@type HighlightGroups
local hi = setmetatable({}, {
  ---@param name string
  ---@param args? vim.api.keyset.highlight
  __newindex = function(_, name, args) vim.api.nvim_set_hl(0, name, args) end,
})

---@param name string
---@param args? vim.api.keyset.highlight
M.new = function(name, args)
  hi[name] = args
  _cached_highlights[name] = args
end

---@param c ColorPalette
---@param fn fun(c:ColorPalette):HighlightGroups
M.apply = function(c, fn)
  -- reapply previously defined highlight groups
  for k, v in pairs(_cached_highlights) do
    vim.api.nvim_set_hl(0, k, v)
  end
  -- enforce styles for builtin highlight groups
  for k, v in pairs(fn(c)) do
    hi[k] = v
  end
  -- ensure termguicolors is set (likely redundant)
  vim.o.termguicolors = true
  -- set gui colors
  vim.g.terminal_color_0 = c.bg2
  vim.g.terminal_color_1 = c.red1
  vim.g.terminal_color_2 = c.green2
  vim.g.terminal_color_3 = c.yellow2
  vim.g.terminal_color_4 = c.blue2
  vim.g.terminal_color_5 = c.magenta1
  vim.g.terminal_color_6 = c.cyan2
  vim.g.terminal_color_7 = c.fg1
  vim.g.terminal_color_8 = c.gray1
  vim.g.terminal_color_9 = c.red1
  vim.g.terminal_color_10 = c.green2
  vim.g.terminal_color_11 = c.yellow2
  vim.g.terminal_color_12 = c.blue2
  vim.g.terminal_color_13 = c.magenta1
  vim.g.terminal_color_14 = c.cyan2
  vim.g.terminal_color_15 = c.fg2
  -- highlighting for special characters
  vim.wo.winhighlight = "SpecialKey:SpecialKeyWin"
end

---@return HighlightGroups
M.get_cached = function() return vim.deepcopy(_cached_highlights) end

return M
