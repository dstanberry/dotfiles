-- verify buftabline is available
local ok, tabline = pcall(require, "buftabline")
if not ok then
  return
end

local icons = require "ui.icons"

tabline.setup {
  tab_format = " #{i} #{b}#{f} ",
  disable_commands = true,
  icons = true,
  go_to_maps = false,
  start_hidden = false,
  flags = {
    modified = pad(icons.misc.FilledCircle, "both"),
    not_modifiable = "",
    readonly = "",
  },
  hlgroups = {
    current = "TabLineSel",
    normal = "TabLine",
  },
  show_tabpages = false,
}
