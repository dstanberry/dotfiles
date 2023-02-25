local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

local BLUE_DARK = color.blend(color.darken(c.blue, 40), c.bg, "66")

groups.new("Dash", { fg = c.yellow_darker, bold = true })
groups.new("CodeBlock", { bg = c.bg_dark })
groups.new("Headline", { bg = BLUE_DARK, bold = true })

return {
  "lukas-reineke/headlines.nvim",
  ft = { "markdown", "yaml" },
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("headlines").setup {
      markdown = {
        fat_headlines = true,
        fat_headline_upper_string = icons.misc.HalfBlockLower,
        fat_headline_lower_string = icons.misc.HalfBlockUpper,
        headline_highlights = { "Headline" },
      },
    }
  end,
}
