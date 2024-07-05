---@class remote.lualine.util
---@field git remote.lualine.component.git
---@field lsp remote.lualine.component.lsp
---@field metadata remote.lualine.component.metadata
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require(string.format("remote.lualine.components.%s", k))
    return t[k]
  end,
})

M.add = function(highlight, items, join)
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

M.highlighter = {
  sanitize = function(group) return "%#" .. group .. "#" end,
  segment = "%=",
  reset = "%*",
}

M.theme = {
  command = {
    a = { fg = vim.g.ds_colors.magenta1, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  inactive = {
    a = { fg = vim.g.ds_colors.fg1, bg = vim.g.ds_colors.gray0 },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  insert = {
    a = { fg = vim.g.ds_colors.green2, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  normal = {
    a = { fg = vim.g.ds_colors.blue1, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  replace = {
    a = { fg = vim.g.ds_colors.orange0, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
  visual = {
    a = { fg = vim.g.ds_colors.red1, bg = vim.g.ds_colors.gray0, bold = true },
    b = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
    c = { fg = vim.g.ds_colors.white, bg = vim.g.ds_colors.gray0 },
  },
}

return M
