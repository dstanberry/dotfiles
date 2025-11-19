---@class remote.lualine.util
---@field git remote.lualine.component.git
---@field message remote.lualine.component.message
---@field metadata remote.lualine.component.metadata
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("remote.lualine.components." .. k)
    return rawget(t, k)
  end,
})

function M.add(highlight, items, join)
  local out = ""
  local sep = join and "" or " "
  for _, item in pairs(items) do
    if item ~= "" then
      if out == "" then
        out = item
      else
        out = string.format("%s%s%s", out, sep, item)
      end
    end
  end
  return string.format("%s%s%s", highlight, out, sep)
end

function M.available_width(width) return vim.api.nvim_get_option_value("columns", {}) >= width end

M.highlighter = {
  sanitize = function(group) return "%#" .. group .. "#" end,
  segment = "%=",
  reset = "%*",
}

function M.theme()
  return {
    command = {
      a = { fg = ds.color "magenta1", bg = ds.color.get("StatusLine", true), gui = "bold" },
      b = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
      c = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
    },
    inactive = {
      a = { fg = ds.color "fg1", bg = ds.color.get("StatusLine", true) },
      b = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
      c = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
    },
    insert = {
      a = { fg = ds.color "green2", bg = ds.color.get("StatusLine", true), gui = "bold" },
      b = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
      c = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
    },
    normal = {
      a = { fg = ds.color "blue1", bg = ds.color.get("StatusLine", true), gui = "bold" },
      b = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
      c = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
    },
    replace = {
      a = { fg = ds.color "orange0", bg = ds.color.get("StatusLine", true), gui = "bold" },
      b = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
      c = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
    },
    visual = {
      a = { fg = ds.color "red1", bg = ds.color.get("StatusLine", true), gui = "bold" },
      b = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
      c = { fg = ds.color "white", bg = ds.color.get("StatusLine", true) },
    },
  }
end

return M
