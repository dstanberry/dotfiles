local c = require("ui.theme").colors
local icons = require "ui.icons"

local M = {}

local label = function() return "MAN" end

M.sections = {
  left = {
    { component = icons.misc.VerticalBarBold, highlight = "mode" },
    { component = label, highlight = { fg = c.fg, bg = c.gray, bold = true } },
    {
      component = "filename",
      highlight = { fg = c.fg, bg = c.gray, bold = true },
      opts = { relative = false },
    },
  },
  right = {},
}

M.filetypes = {
  "man",
}

return M
