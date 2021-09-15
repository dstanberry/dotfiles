-- verify nvim-web-devicons is available
local ok, devicons = pcall(require, "nvim-web-devicons")
if not ok then
  return
end

-- define custom icons based on filetype
devicons.setup {
  override = require "remote.devicons.icons",
  default = true,
}
