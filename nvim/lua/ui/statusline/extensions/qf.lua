local icons = require "ui.icons"

local M = {}

local is_loclist = function()
  local loclist = vim.fn.getloclist(0, { filewinid = 1 })
  return loclist.filewinid ~= 0
end

local label = function()
  return is_loclist() and "Location List" or "Quickfix List"
end

local title = function()
  local list
  if is_loclist() then
    return vim.fn.getloclist(0, { title = 0 }).title
  end
  return vim.fn.getqflist({ title = 0 }).title
end

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { user2 = label },
    { user8 = title },
  },
  right = {},
}

M.filetypes = {
  "qf",
}

return M