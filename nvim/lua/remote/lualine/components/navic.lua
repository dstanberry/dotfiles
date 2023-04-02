local icons = require "ui.icons"
local util = require "util"

local stl_util = require "remote.lualine.util"

local add = stl_util.add
local highlighter = stl_util.highlighter

local separator = highlighter.sanitize "NavicSeparator" .. pad(icons.misc.CaretRight, "both") .. highlighter.reset
local format_ellipses = add(highlighter.sanitize "NavicText", { "..." }, true)

local format_context = function(type, icon, name)
  return add(highlighter.sanitize(("%s%s"):format("NavicIcons", type)), { pad(icon, "left"), highlighter.reset }, true)
    .. add(highlighter.sanitize "NavicText", { name, highlighter.reset }, true)
end

return function()
  local navic = require "nvim-navic"
  local winid = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(winid)
  local data = navic.get_data(buf)
  if not data then return "" end
  local limit = math.floor(0.4 * vim.fn.winwidth(winid))
  local estimated_size = 3
  local max_reached = false
  local context = util.map(function(context, v, k)
    local name = v.name:gsub("%%", "%%%%"):gsub("\n", " ")
    estimated_size = estimated_size + #v.icon + #name + 3
    if estimated_size < (limit - 5) then
      context[k] = format_context(v.type, v.icon, name)
    elseif not max_reached then
      max_reached = true
      context[k] = format_ellipses
    end
    return context
  end, data)
  return #context > 1 and separator .. table.concat(context, separator) or ""
end
