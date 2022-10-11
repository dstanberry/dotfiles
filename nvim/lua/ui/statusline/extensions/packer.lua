local icons = require "ui.icons"

local M = {}

local function label()
  return "Packer"
end

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { modehl = label },
  },
  right = {},
}

M.filetypes = {
  "packer",
}

return M
