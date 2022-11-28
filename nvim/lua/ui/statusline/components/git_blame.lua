local has_signs, _ = pcall(require, "gitsigns")

local M = require("ui.statusline.components._class"):extend()

function M:load()
  local info = ""
  if has_signs then
    info = vim.b.gitsigns_blame_line ~= nil and vim.b.gitsigns_blame_line or ""
  end
  self.label = info
end

return M
