local icons = require "ui.icons"

local M = require("ui.statusline.components._class"):extend()

function M:load()
  local result = {}
  local levels = {
    error = vim.diagnostic.severity.ERROR,
    warn = vim.diagnostic.severity.WARN,
  }
  for k, level in pairs(levels) do
    result[k] = #vim.diagnostic.get(self.options.buf, { severity = level })
  end
  local errors = pad(icons.status.Error, "right") .. result.error
  local warnings = pad(icons.status.Warn, "both") .. result.warn
  self.label = errors .. warnings
end

return M
