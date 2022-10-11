local icons = require "ui.icons"

local M = {}

local function label()
  return "ToggleTerm #" .. vim.b.toggle_number
end

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { modehl = label },
  },
  right = {},
}

M.filetypes = {
  "toggleterm",
}

return M
