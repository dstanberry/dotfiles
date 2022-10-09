local M = require("ui.statusline.components._class"):extend()

function M:load()
  local line = vim.fn.line('.')
  local col = vim.fn.virtcol('.')
  self.label = string.format('%3d:%-2d', line, col)
end

return M
