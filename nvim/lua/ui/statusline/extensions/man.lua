local icons = require "ui.icons"

local M = {}

local label = function()
  return "MAN"
end

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { modehl = label },
    { user8 = { "filename", relative = false } },
  },
  right = {},
}

M.filetypes = {
  "man",
}

return M
