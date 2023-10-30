local color = require "util.color"

---@type ColorPalette
---@diagnostic disable-next-line: missing-fields
local mocha = {
  bg0 = "#11111b", --crust
  bg1 = "#181825", --mantle
  bg2 = "#1e1e2e", --base
  bg3 = "#24273a",
  bg4 = "#303446",

  fg0 = "#a6adc8", --subtext0
  fg1 = "#bac2de", --subtext1
  fg2 = "#cdd6f4", --text

  gray0 = "#313244", --surface2
  gray1 = "#45475a", --surface1
  gray2 = "#585b70", --surface0

  rose0 = "#f2cdcd", --flamingo
  rose1 = "#f5e0dc", --rosewater

  red0 = "#eba0ac", --maroon
  red1 = "#f38ba8", --red
  red2 = "#c06d84",
  red3 = "#8d5060",

  orange0 = "#fab387", --peach
  orange1 = "#ffab87",

  yellow0 = "#e4c78f",
  yellow1 = "#f9e2af", --yellow
  yellow2 = "#ffecb3",

  green0 = "#a6d189",
  green1 = "#a6e3a1", --green
  green2 = "#b0f8af",

  cyan0 = "#8bd5ca",
  cyan1 = "#94e2d5", --teal
  cyan2 = "#a0e2d7",

  aqua0 = "#74c7ec", --sapphire
  aqua1 = "#89dceb", --sky
  aqua2 = "#94e7ff",

  blue0 = "#6d8fc6",
  blue1 = "#89b4fa", --blue
  blue2 = "#93b4ff",
  blue3 = "#afc1f1",
  blue4 = "#b3c9f6",

  purple0 = "#b4befe", --lavender
  purple1 = "#cba6f7", --mauve

  magenta0 = "#c299b6",
  magenta1 = "#ddb9d7",
  magenta2 = "#f5c2e7", --pink

  -- c.overlay0 = "#6c7086"
  -- c.overlay1 = "#7f849c"
}

mocha.black = color.darken(mocha.bg2, 50)
mocha.white = color.darken(mocha.fg1, 10)

mocha.bgX = color.blend(mocha.bg0, mocha.bg2, 0.31)
mocha.bg_visual = "#585b70"

mocha.fg_conceal = color.blend(mocha.magenta2, mocha.bg2, 0.44)
mocha.fg_comment = "#9399b2"

mocha.grayX = color.darken(mocha.gray1, 25)

mocha.diff_add = "#a5e2a0"
mocha.diff_delete = "#f38ba8"
mocha.diff_text = "#87b2f9"
mocha.diff_change = color.blend(mocha.diff_text, mocha.bg3, 0.2)

return mocha
