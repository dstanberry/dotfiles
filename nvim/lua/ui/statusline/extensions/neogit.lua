local icons = require "ui.icons"

local M = {}

local function label() return "Neogit" end

M.sections = {
  left = {
    { component = icons.misc.VerticalBarBold, highlight = "mode" },
    { component = label, highlight = "mode" },
  },
  right = {},
}

M.filetypes = {
  "NeogitPopup",
  "NeogitStatus",
}

return M
