-- verify nvim-web-devicons is available
local ok, devicons = pcall(require, "nvim-web-devicons")
if not ok then
  return
end

local custom = require "remote.devicons.icons"
local documents = require("ui.icons").documents

devicons.setup {
  default = false,
  -- this currently won't work because `loaded` cannot be reset
  override = custom,
}

devicons.set_default_icon(documents.File, "#6d8086")

for key, value in pairs(custom) do
  devicons.set_icon { [key] = value }
end
