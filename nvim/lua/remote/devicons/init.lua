-- verify nvim-web-devicons is available
local ok, devicons = pcall(require, "nvim-web-devicons")
if not ok then
  return
end

devicons.setup {
  override = require "remote.devicons.icons",
  default = true,
}

devicons.set_default_icon('', '#6d8086')
