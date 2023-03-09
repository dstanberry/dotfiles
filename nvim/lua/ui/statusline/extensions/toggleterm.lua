local icons = require "ui.icons"

local M = {}

local function label() return "ToggleTerm #" .. vim.b.toggle_number end

M.sections = {
  left = {
    { component = icons.misc.VerticalBarBold, highlight = "mode" },
    { component = label, highlight = "mode" },
  },
  right = {},
}

M.filetypes = {
  "toggleterm",
}

return M
