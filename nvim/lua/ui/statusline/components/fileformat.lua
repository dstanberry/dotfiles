local M = require("ui.statusline.components._class"):extend()

function M:load()
  self.label = ""
  local format = vim.api.nvim_buf_get_option(self.options.buf, "fileformat")
  if format == "unix" then
    self.label = "lf"
  end
  if format == "dos" then
    self.label = "crlf"
  end
end

return M
