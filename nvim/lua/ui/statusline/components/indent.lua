local M = require("ui.statusline.components._class"):extend()

function M:load()
  if vim.bo[self.options.buf].expandtab then
    self.label = ("spaces: %s"):format(vim.bo[self.options.buf].shiftwidth)
  else
    self.label = ("tabs: %s"):format(vim.bo[self.options.buf].tabstop)
  end
end

return M
