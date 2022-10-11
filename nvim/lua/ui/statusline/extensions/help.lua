local icons = require "ui.icons"

local M = {}

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { user8 = { "filename", relative = true, file_status = false } },
  },
  right = {},
}

M.filetypes = {
  "help",
}

return M
