local color = require "util.color"

---@type ColorPalette
---@diagnostic disable-next-line: missing-fields
local c = {
  bg0 = "#232634", --crust
  bg1 = "#292c3c", --mantle
  bg2 = "#303446", --base
  bg3 = "#40455d",
  bg4 = "#494f6a",

  fg0 = "#a5adce", --subtext0
  fg1 = "#b5bfe2", --subtext1
  fg2 = "#cdd6f4", --text

  gray0 = "#414559", --surface0
  gray1 = "#51576d", --surface1
  gray2 = "#626880", --surface2

  rose0 = "#eebebe", --flamingo
  rose1 = "#f2d5cf", --rosewater

  red0 = "#ea999c", --maroon
  red1 = "#e78284", --red
  red2 = "#d27476",
  red3 = "#a55d5e",

  orange0 = "#ef9f76", --peach
  orange1 = "#dd936d",

  yellow0 = "#f1d398",
  yellow1 = "#e5c890", --yellow
  yellow2 = "#c8ae7d",

  green0 = "#b3e294",
  green1 = "#a6d189", --green
  green2 = "#b0f8af",

  cyan0 = "#8bd5ca",
  cyan1 = "#81c8be", --teal
  cyan2 = "#a0e2d7",

  aqua0 = "#85c1dc", --sapphire
  aqua1 = "#99d1db", --sky
  aqua2 = "#94e7ff",

  blue0 = "#6d8fc6",
  blue1 = "#8caaee", --blue
  blue2 = "#93b4ff",
  blue3 = "#afc1f1",
  blue4 = "#b3c9f6",

  purple0 = "#babbf1", --lavender
  purple1 = "#ca9ee6", --mauve

  magenta0 = "#c299b6",
  magenta1 = "#ddb9d7",
  magenta2 = "#f4b8e4", --pink

  overlay0 = "#737994",
  overlay1 = "#838ba7",
}

c.black = color.darken(c.bg2, 50)
c.white = color.darken(c.fg1, 10)

c.bgX = color.blend(c.bg0, c.bg2, 0.31)
c.bg_visual = "#585b70"

c.fg_conceal = color.blend(c.magenta2, c.bg2, 0.44)
c.fg_comment = "#9399b2"

c.grayX = color.darken(c.gray1, 25)

c.diff_add = "#a5e2a0"
c.diff_delete = "#f38ba8"
c.diff_text = "#87b2f9"
c.diff_change = color.blend(c.diff_text, c.bg3, 0.2)

return c
