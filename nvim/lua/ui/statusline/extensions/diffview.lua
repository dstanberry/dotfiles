local icons = require "ui.icons"

local M = {}

local statusline_label = function(options)
  local name = "Diffview"
  local split = vim.split(options.name, "/", { plain = true })
  if #split > 1 then
    name = split[#split]
  end
  return name
end

M.sections = {
  left = {
    { modehl = icons.misc.VerticalBarBold },
    { modehl = statusline_label },
  },
  right = {},
}

M.filetypes = {
  "DiffviewFiles",
}

return M
