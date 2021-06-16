---------------------------------------------------------------
-- => nvim-web-devicons configuration
---------------------------------------------------------------
-- verify nvim-web-devicons is available
local has_devicons, devicons = pcall(require, "nvim-web-devicons")
if not has_devicons then
  return
end

-- define custom icons based on filetype
devicons.setup {
  override = require "remote.devicons.icons",
}
