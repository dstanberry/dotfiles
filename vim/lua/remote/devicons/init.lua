---------------------------------------------------------------
-- => nvim-web-devicons configuration
---------------------------------------------------------------
-- verify nvim-web-devicons is available
local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
if not has_devicons then
  return
end

-- helper function to get corresponding icon for filetype
function GetDevIcon(path, ext)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = ext or vim.fn.fnamemodify(path, ':e')
  return devicons.get_icon(filename, extension, {default = true})
end

-- define custom icons based on filetype
devicons.setup {
  override = require 'remote.devicons.icons'
}
