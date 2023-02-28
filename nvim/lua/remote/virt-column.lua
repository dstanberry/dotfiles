local groups = require "ui.theme.groups"
local icons = require "ui.icons"

groups.new("VirtColumn", { link = "NonText" })

return {
  "lukas-reineke/virt-column.nvim",
  event = "VimEnter",
  opts = { char = icons.misc.VerticalBarVeryThin },
}
