local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

local BG_LIGHT = color.blend(c.gray_alt, c.bg, "70")
local BLUE_DARK = color.blend(color.darken(c.blue, 40), c.bg, "66")
local MAGENTA_DARK = color.blend(color.darken(c.magenta, 40), c.bg, "66")
local ORANGE_DARK = color.blend(color.darken(c.orange, 40), c.bg, "66")
local TEAL_DARK = color.blend(color.darken(c.teal, 40), c.bg, "66")
local BLUE_LIGHT = color.blend(color.darken(c.blue_light, 40), c.bg, "66")
local BLUE_ALT = color.blend(color.darken(c.blue_alt, 40), c.bg, "66")

groups.new("CodeBlock", { bg = BG_LIGHT })
groups.new("Dash", { fg = c.yellow_darker, bold = true })
groups.new("Headline1", { bg = BLUE_DARK })
groups.new("Headline2", { bg = MAGENTA_DARK })
groups.new("Headline3", { bg = ORANGE_DARK })
groups.new("Headline4", { bg = TEAL_DARK })
groups.new("Headline5", { bg = BLUE_LIGHT })
groups.new("Headline6", { bg = BLUE_ALT })

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
        headline_highlights = { "Headline1", "Headline2", "Headline3", "Headline4", "Headline5", "Headline6" },
      },
    }
  end,
}
