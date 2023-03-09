local icons = require "ui.icons"

local M = {}

local function label() return "Terminal |" .. vim.o.shell .. "|" end

M.sections = {
  left = {
    { component = icons.misc.VerticalBarBold, highlight = "mode" },
    { component = label, highlight = "mode" },
  },
  right = {},
}

M.filetypes = {
  "term",
}

return M
