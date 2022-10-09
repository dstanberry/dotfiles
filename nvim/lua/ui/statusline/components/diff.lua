local has_signs, _ = pcall(require, "gitsigns")

local icons = require "ui.icons"

local M = require("ui.statusline.components._class"):extend()

function M:load()
  self.label = has_signs and vim.b.gitsigns_status or ""
end

return M
