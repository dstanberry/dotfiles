local M = require("ui.statusline.components._class"):extend()

function M:load()
  self.label = "utf-8"
  local enc = vim.api.nvim_buf_get_option(self.options.buf, "fileencoding")
  if #enc > 0 then self.label = enc end
end

return M
