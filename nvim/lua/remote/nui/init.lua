local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"

groups.new("NuiCursorLine", {})
groups.new("NuiLabel", { fg = c.white })
groups.new("NuiNormalFloat", { fg = c.white })
groups.new("NuiGapFloat", {})
groups.new("NuiResultsFloat", {})
groups.new("NuiFloatBorder", { fg = color.blend(c.gray1, c.blue0, 0.44) })
groups.new("NuiComponentsButton", { link = "NormalSB" })
groups.new("NuiComponentsButtonActive", { link = "PMenuSel" })
groups.new("NuiComponentsCheckboxIcon", { fg = c.fg0 })
groups.new("NuiComponentsCheckboxIconChecked", { fg = c.magenta2, bold = true })
groups.new("NuiComponentsCheckboxLabel", { link = "NuiComponentsCheckboxIcon" })
groups.new("NuiComponentsCheckboxLabelChecked", { link = "NuiComponentsCheckboxIconChecked" })

return {
  {
    "grapp-dev/nui-components.nvim",
    keys = {
      {
        "<localleader>sr",
        function() require("remote.nui.pickers.spectre").toggle() end,
        desc = "spectre: replace in files",
      },
    },
  },
  { "MunifTanjim/nui.nvim", lazy = true },
}
