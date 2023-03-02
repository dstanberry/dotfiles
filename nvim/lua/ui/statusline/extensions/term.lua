local icons = require "ui.icons"

local M = {}

local function label() return "Terminal |" .. vim.o.shell .. "|" end

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { modehl = label },
  },
  right = {},
}

M.filetypes = {
  "term",
}

return M
