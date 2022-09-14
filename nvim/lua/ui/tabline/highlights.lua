local groups = require "ui.theme.groups"

local M = {}

local icon_hls = {}

local get_hl_attribute = function(hl, attribute)
  local rgb_val = vim.api.nvim_get_hl_by_name(hl, true)[attribute]
  return rgb_val and string.format("#%06x", rgb_val) or "NONE"
end

local define_hl = function(name, fg, bg)
  groups.new(name, { fg = fg, bg = bg })
  icon_hls[name] = true
end

M.merge_hl = function(fg_hl, bg_hl)
  local merged = fg_hl .. bg_hl
  if not icon_hls[merged] then
    define_hl(merged, get_hl_attribute(fg_hl, "foreground"), get_hl_attribute(bg_hl, "background"))
  end
  return merged
end

M.add_hl = function(text, hl)
  return string.format("%%#%s#%s%%*", hl, text)
end

M.reset = function()
  icon_hls = {}
end

return M
