local icons = require "ui.icons"

local M = {}

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { user8 = { "filename", relative = true } },
  },
  right = {},
}

M.filetypes = {
  "lir",
}

return M
