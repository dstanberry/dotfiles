local icons = require "ui.icons"

local M = {}

local function label() return "Neogit" end

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { modehl = label },
  },
  right = {},
}

M.filetypes = {
  "NeogitPopup",
  "NeogitStatus",
}

return M
