local icons = require "ui.icons"

local M = {}

local statusline_label = function(options)
  local name = "Diffview"
  local split = vim.split(options.name, "/", { plain = true })
  if #split > 1 then name = split[#split] end
  return name
end

M.sections = {
  left = {
    { component = icons.misc.VerticalBarBold, highlight = "mode" },
    { component = statusline_label, highlight = "mode" },
  },
  right = {},
}

M.filetypes = {
  "diffview",
  "DiffviewFiles",
}

return M
