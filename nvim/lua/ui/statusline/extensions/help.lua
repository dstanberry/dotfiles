local c = require("ui.theme").colors
local icons = require "ui.icons"

local M = {}

M.sections = {
  left = {
    { component = icons.misc.VerticalBarBold, highlight = "mode" },
    {
      component = "filename",
      highlight = { fg = c.fg, bg = c.gray, bold = true },
      opts = { relative = true, file_status = false },
    },
  },
  right = {},
}

M.filetypes = {
  "help",
}

return M
