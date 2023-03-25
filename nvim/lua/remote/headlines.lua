local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

local BG = color.blend(c.grayX, c.bg2, "70")
local FG = color.blend(color.darken(c.fg2, 40), c.bg2, "66")
local AQUA = color.blend(color.darken(c.aqua1, 40), c.bg2, "66")
local MAGENTA = color.blend(color.darken(c.magenta1, 40), c.bg2, "66")

groups.new("CodeBlock", { bg = BG })
groups.new("Dash", { fg = c.yellow0, bold = true })
groups.new("Headline1", { bg = AQUA })
groups.new("Headline2", { bg = MAGENTA })
groups.new("Headline3", { bg = FG })
groups.new("Headline4", { bg = FG })
groups.new("Headline5", { bg = FG })
groups.new("Headline6", { bg = FG })

return {
  {
    "lukas-reineke/headlines.nvim",
    ft = { "markdown", "yaml" },
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = false,
    config = function()
      require("headlines").setup {
        markdown = {
          fat_headlines = true,
          fat_headline_upper_string = icons.misc.HalfBlockLower,
          fat_headline_lower_string = icons.misc.HalfBlockUpper,
          headline_highlights = false,
        },
      }
    end,
  },
}
