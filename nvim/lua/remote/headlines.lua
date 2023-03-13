local c = require("ui.theme").colors
local color = require "util.color"
local groups = require "ui.theme.groups"
local icons = require "ui.icons"

local BG = color.blend(c.grayX, c.bg2, "70")
local BLUE = color.blend(color.darken(c.blue2, 40), c.bg2, "66")
local MAGENTA = color.blend(color.darken(c.magenta1, 40), c.bg2, "66")
local ORANGE = color.blend(color.darken(c.orange0, 40), c.bg2, "66")
local CYAN = color.blend(color.darken(c.cyan1, 40), c.bg2, "66")
local AQUA_DARK = color.blend(color.darken(c.aqua1, 40), c.bg2, "66")
local AQUA = color.blend(color.darken(c.aqua0, 40), c.bg2, "66")

groups.new("CodeBlock", { bg = BG })
groups.new("Dash", { fg = c.yellow0, bold = true })
groups.new("Headline1", { bg = BLUE })
groups.new("Headline2", { bg = MAGENTA })
groups.new("Headline3", { bg = ORANGE })
groups.new("Headline4", { bg = CYAN })
groups.new("Headline5", { bg = AQUA_DARK })
groups.new("Headline6", { bg = AQUA })

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
